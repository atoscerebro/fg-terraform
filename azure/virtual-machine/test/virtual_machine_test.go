package test

import (
	"testing"

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

func (suite *VirtualMachineIntegrationSuite) TestVirtualMachine_Deploy() {
	options := terraform.WithDefaultRetryableErrors(suite.T(), &terraform.Options{
		TerraformDir: "./module",
		Vars: map[string]interface{}{
			"name":                 "vm-name",
			"resource_group_name":  suite.rg_name,
			"virtual_network_name": suite.vnet_name,
			"subnet_name":          suite.subnet_name,
			"admin_username":       "atos",
		},
	})

	_, err := terraform.InitAndApplyE(suite.T(), options)

	defer terraform.Destroy(suite.T(), options)

	assert.NoError(suite.T(), err)
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
