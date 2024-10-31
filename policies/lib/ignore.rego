package lib.ignore

import data.lib.core
import data.lib.pods
import future.keywords.in

default default_ignore_annotation_key = "gatekeeper.cyberagent.co.jp/ignore-containers"

is_ignore_container(container, parameters) {
    ignore_containers := { trim(ic, " ") |
        ic := split(trim(object.get(pods.pod.metadata.annotations, default_ignore_annotation_key, ""), " "), ",")[_]
    }
    ignore_containers[_] == container.name
}

is_ignore_container(container, parameters) {
    core.has_field(parameters, "ignoreContainersAnnotationKey")
    ignore_annotation_key = parameters["ignoreContainersAnnotationKey"]
    ignore_containers := { trim(ic, " ") |
        ic := split(trim(object.get(pods.pod.metadata.annotations, ignore_annotation_key, ""), " "), ",")[_]
    }
    ignore_containers[_] == container.name
}

is_ignore_container(container, parameters) {
    core.has_field(parameters, "ignoreContainersName")
    ignore_containers := parameters["ignoreContainersName"]
    ignore_containers[_] == container.name
}
