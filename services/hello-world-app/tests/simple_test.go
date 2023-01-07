package tests

import (
	"fmt"
	httpHelper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
	"testing"
	"time"
)

func TestHelloWorldAppSimpleExample(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../examples/simple",

		Vars: map[string]interface{}{
			"db_config": map[string]interface{}{
				"db_address": "dummy-mysql-server",
				"db_port":    3306,
			},
			"environment": fmt.Sprintf("test-%s", random.UniqueId()),
		},
	}
	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	url := terraform.OutputRequired(t, opts, "server_url")

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	// Test that the server is up and running
	httpHelper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 &&
				strings.Contains(body, "Hello Dude!") &&
				strings.Contains(body, "dummy-mysql-server")
		},
	)
}
