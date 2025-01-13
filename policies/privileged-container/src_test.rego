package privileged_container

test_privileged_container {
    input := {
        "securityContext": {
            "privileged": true
        }
    }

    container_is_privileged(input)
}

test_not_privileged_container {
    input := {
        "securityContext": {
            "privileged": false
        }
    }

    not container_is_privileged(input)
}

test_blank_privileged_container {
    input := {
        "securityContext": {}
    }

    not container_is_privileged(input)
}
