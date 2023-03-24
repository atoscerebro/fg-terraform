package test

import (
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2019-07-01/compute"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
)

func TestVirtualMachine_Validate(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "..",
	})

	_, err := terraform.InitAndValidateE(t, terraformOptions)

	assert.NoError(t, err)
}

type VirtualMachineIntegrationSuite struct {
	suite.Suite
	options     *terraform.Options
	rg_name     string
	vnet_name   string
	subnet_name string
}

func (suite *VirtualMachineIntegrationSuite) SetupSuite() {
	suite.options = terraform.WithDefaultRetryableErrors(suite.T(), &terraform.Options{
		TerraformDir: "./env",
		Vars: map[string]interface{}{
			"id": random.UniqueId(),
		},
	})

	_, err := terraform.InitAndApplyE(suite.T(), suite.options)

	assert.NoError(suite.T(), err)

	suite.rg_name = terraform.Output(suite.T(), suite.options, "rg_name")
	suite.vnet_name = terraform.Output(suite.T(), suite.options, "vnet_name")
	suite.subnet_name = terraform.Output(suite.T(), suite.options, "subnet_name")
}

func (suite *VirtualMachineIntegrationSuite) Test_Deploy() {
	name := "vm-name"
	options := terraform.WithDefaultRetryableErrors(suite.T(), &terraform.Options{
		TerraformDir: "./module",
		Vars: map[string]interface{}{
			"name":                 name,
			"resource_group_name":  suite.rg_name,
			"virtual_network_name": suite.vnet_name,
			"subnet_name":          suite.subnet_name,
			"admin_username":       "atos",
		},
	})

	_, err := terraform.InitAndApplyE(suite.T(), options)

	defer terraform.Destroy(suite.T(), options)

	assert.NoError(suite.T(), err)

	suite.T().Run("Test_Default_Location", func(t *testing.T) {
		actualLocation := azure.GetVirtualMachine(t, name, suite.rg_name, "")
		expectedLocation := "westeurope"
		assert.Equal(t, expectedLocation, *actualLocation.Location)
	})

	suite.T().Run("Test_Default_Size", func(t *testing.T) {
		actualVMSize := azure.GetSizeOfVirtualMachine(t, name, suite.rg_name, "")
		expectedVMSize := compute.VirtualMachineSizeTypes("Standard_DS1_v2")
		assert.Equal(t, expectedVMSize, actualVMSize)
	})
}

func (suite *VirtualMachineIntegrationSuite) TearDownSuite() {
	_, err := terraform.DestroyE(suite.T(), suite.options)

	assert.NoError(suite.T(), err)
}

func TestVirtualMachine_Integration(t *testing.T) {
	if testing.Short() {
		t.Skip("Skipping test because -short is set")
	}
	suite.Run(t, new(VirtualMachineIntegrationSuite))
}
