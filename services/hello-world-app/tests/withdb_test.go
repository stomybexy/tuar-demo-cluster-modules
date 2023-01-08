package tests

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"strings"
	"testing"
	"time"
)

func TestHelloWorldAppWithDb(t *testing.T) {
	t.Parallel()

	dbName := fmt.Sprintf("testdb%s", random.UniqueId())
	greeting := "Hi there!"
	opts := &terraform.Options{
		TerraformDir: "../examples/withdb",

		Vars: map[string]interface{}{
			"environment": fmt.Sprintf("test-%s", random.UniqueId()),
			"greeting":    greeting,
			"db_username": "test",
			"db_password": fmt.Sprintf("test123%s", random.UniqueId()),
			"db_name":     dbName,
		},
	}
	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	url := terraform.OutputRequired(t, opts, "server_url")
	dbAddress := terraform.OutputRequired(t, opts, "db_address")

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 &&
				strings.Contains(body, greeting) &&
				strings.Contains(body, dbAddress)
		},
	)
}
