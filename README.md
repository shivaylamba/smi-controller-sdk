# SMI Controller SDK

This project is a scaffold Kubernetes controller for the SMI specification.

Projects that would like to build a SMI Spec complient controller only need to 
define a plugin that implement the extension points defined by the SDK.  

Core Kubernetes controller methods that handle the lifecylcle are implemented by the SDK and 
the methods in your API are called accordingly.

## Implementing the SDK and creating a controller

To implement the SDK you need to create structs which implement the API callback methods.
Your callbacks contain the Service Mesh specific logic needed to be executed when SMI Spec resources
are processed by the Kubernetes cluster.

For example, to create a simple implemntation which logs when a SMI resource is added or removed from
the system, you create a struct like the following example.

```go
type loggerV2 struct {}

func (l *loggerV2) UpsertTrafficTarget(ctx context.Context, c client.Client, log logr.Logger, tt *accessv1alpha2.TrafficTarget) (ctrl.Result, error) {
	log.Info("UpsertTrafficTarget", "api", "v1alpha2", "target", tt)

	return ctrl.Result{}, nil
}

func (l *loggerV2) DeleteTrafficTarget(ctx context.Context, c client.Client, log logr.Logger, tt *accessv1alpha2.TrafficTarget) (ctrl.Result, error) {
	log.Info("DeleteTrafficTarget", "api", "v1alpha2", "target", tt)

	return ctrl.Result{}, nil
}
```

You then register these callbacks with the controller API, when the controller needs to action a change 
to a SMI Spec resource it calls the apropriate callback. For example, when a new `TrafficTarget` is 
received by the controller the `loggerV2.UpsertTrafficTarget` method is called.

```go
mesh.API().RegisterV1Alpha2(newLoggerV1Alpha2())
```

And create and start the controller

```go
c := &pkg.SMIController{}
c.Start()
}
```

The full 

```go
package main

import (
	"github.com/nicholasjackson/smi-controller/mesh"
	"github.com/nicholasjackson/smi-controller/pkg"
)

loggerV2 struct {}

func (l *loggerV2) UpsertTrafficTarget(ctx context.Context, c client.Client, log logr.Logger, tt *accessv1alpha2.TrafficTarget) (ctrl.Result, error) {
	log.Info("UpsertTrafficTarget", "api", "v1alpha2", "target", tt)

	return ctrl.Result{}, nil
}

func (l *loggerV2) DeleteTrafficTarget(ctx context.Context, c client.Client, log logr.Logger, tt *accessv1alpha2.TrafficTarget) (ctrl.Result, error) {
	log.Info("DeleteTrafficTarget", "api", "v1alpha2", "target", tt)

	return ctrl.Result{}, nil
}

func main() {
	// register our lifecycle callbacks onto the API
	mesh.API().RegisterV1Alpha2(&loggerV2{}))

	// create and start a the controller
	c := &pkg.SMIController{}
	c.Start()
}
```
