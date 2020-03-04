Configuration SSH {
    Import-DscResource -ModuleName WindowsCapabilityDsc
    Node localhost {
        WindowsCapabilityResource sshd {
            Name = "OpenSSH.Server~~~~0.0.1.0"
            Ensure = "Present"
        }
    }
}
