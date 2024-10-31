# METADATA
# title: privileged_container
# custom:
#   skipConstraint: true
#   matchers:
#     kinds:
#     - apiGroups:
#       - ""
#       kinds:
#       - Pod
#     - apiGroups:
#       - apps
#       kinds:
#       - Deployment
#       - ReplicaSet
#       - StatefulSet
#       - DaemonSet
#     - apiGroups:
#       - batch
#       kinds:
#       - Job
#       - CronJob
#   parameters:
#     ignoreContainersAnnotationKey:
#       type: string
#     ignoreContainersName:
#       type: array
#       items:
#         type: string

package privileged_container

import data.lib.core
import data.lib.pods
import data.lib.ignore

policyID := "privileged-container"

violation[msg] {
    c := pods.containers[_]
    container_is_privileged(c)
    not ignore.is_ignore_container(c, input.parameters)

    msg = core.format_with_id(
        sprintf("apiVersion: %v, kind: %v, name: %v, container: %v; container runs as privileged", [
            core.apiVersion, core.kind, core.name, c.name
        ]),
        policyID
    )
}

container_is_privileged(c) {
    c.securityContext.privileged
}
