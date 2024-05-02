package test

import (
	"context"
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/require"
        metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func TestArgoCDDeployment(t *testing.T) {
	// Create a Kubernetes client.
	kubeConfigPath := "~/.kube/config"
	kubeClient, err := k8s.NewKubernetesClientFromPathE(kubeConfigPath)
	require.NoError(t, err)

	// Define the expected resources.
	expectedResources := []string{
		"argocd-server",
		"argocd-application-controller",
		"argocd-redis",
		"argocd-repo-server",
	}

	// Check that the expected resources are present.
	for _, resource := range expectedResources {
		_, err := kubeClient.AppsV1().Deployments("argocd").Get(context.Background(), resource, metav1.GetOptions{})
		require.NoError(t, err, "deployment %s not found", resource)
	}

	// Check that the ArgoCD server is accessible.
	//argoCDServerEndpoint := "<ArgoCD server endpoint>"
	//response, err := http.Get(argoCDServerEndpoint)
	//require.NoError(t, err)
	//defer response.Body.Close()
	//assert.Equal(t, http.StatusOK, response.StatusCode)
}
