package lib.ignore

test_ignore {
    containers := [{
        "name": "foo"
    }, {
        "name": "bar"
    }, {
        "name": "baz"
    }]
    input := {
        "kind": "Pod",
        "metadata": {
            "annotations": {
                default_ignore_annotation_key: "foo"
            }
        },
        "spec": {
            "containers": containers
        },
        "parameters": {
        }
    }

    is_ignore_container(containers[0], input.parameters) with input as input
    not is_ignore_container(containers[1], input.parameters) with input as input
    not is_ignore_container(containers[2], input.parameters) with input as input
}

test_ignore_trim {
    containers := [{
        "name": "foo"
    }, {
        "name": "bar"
    }, {
        "name": "baz"
    }]
    input := {
        "kind": "Pod",
        "metadata": {
            "annotations": {
                default_ignore_annotation_key: "   foo  , bar "
            }
        },
        "spec": {
            "containers": containers
        },
        "parameters": {
        }
    }

    is_ignore_container(containers[0], input.parameters) with input as input
    is_ignore_container(containers[1], input.parameters) with input as input
    not is_ignore_container(containers[2], input.parameters) with input as input
}

test_ignore_deployment {
    containers := [{
        "name": "foo"
    }, {
        "name": "bar"
    }, {
        "name": "baz"
    }]
    input := {
        "kind": "Deployment",
        "metadata": {},
        "spec": {
            "replicas": 1,
            "selector": {
                "matchLabels": {
                    "foo": "bar"
                }
            },
            "template": {
                "metadata": {
                    "annotations": {
                        default_ignore_annotation_key: "foo,baz"
                    }
                },
                "spec": {
                    "containers": containers
                }
            }
        },
        "parameters": {
        }
    }

    is_ignore_container(containers[0], input.parameters) with input as input
    not is_ignore_container(containers[1], input.parameters) with input as input
    is_ignore_container(containers[2], input.parameters) with input as input
}

test_ignore_parameter {
    ignore_annotation_key := "test.gatekeeper.gatekeeper-policies-playground.dev/ignore-containers"

    containers := [{
        "name": "foo"
    }, {
        "name": "bar"
    }, {
        "name": "baz"
    }]
    input := {
        "review": {
            "object": {
                "kind": "Pod",
                "metadata": {
                    "annotations": {
                        ignore_annotation_key: "foo"
                    }
                },
                "spec": {
                    "containers": containers
                }
            }
        },
        "parameters": {
            "ignoreContainersAnnotationKey": ignore_annotation_key
        }
    }

    is_ignore_container(containers[0], input.parameters) with input as input
    not is_ignore_container(containers[1], input.parameters) with input as input
    not is_ignore_container(containers[2], input.parameters) with input as input
}

test_ignore_name {
    containers := [{
        "name": "foo"
    }, {
        "name": "bar"
    }, {
        "name": "baz"
    }]
    input := {
        "review": {
            "object": {
                "kind": "Pod",
                "spec": {
                    "containers": containers
                }
            }
        },
        "parameters": {
            "ignoreContainersName": ["foo", "bar"]
        }
    }

    is_ignore_container(containers[0], input.parameters) with input as input
    is_ignore_container(containers[1], input.parameters) with input as input
    not is_ignore_container(containers[2], input.parameters) with input as input
}
