
# Sign in to a virtual machine in Azure by using Microsoft Entra ID

This is document describes how to enable and perform the sign in to a VM hosted in Azure with an Entra ID account instead of using a local account.

There are some differences between Windows and Linux VMs. For both VM types, Azure RBAC configuration must be done. This could be the first step in enabling this feature.

## Azure RBAC

<!-- [ ] description of nescesary RBAC roles -->

## AADLogin extension for Windows

The AADLoginForWindows can only be added to VMs with the OS

- Windows Server 2019 Datacenter and later _(Server Core is not supported :exclamation:)_
- Windows 10 1809 and later
- Windows 11 21H2 and later

For more requirements read the [documentation](https://learn.microsoft.com/en-us/entra/identity/devices/howto-vm-sign-in-azure-ad-windows#requirements).

### Adding the extension for Windows

#### Portal

It's possible to add the extension at the moment you create a new VM. In the portal check the option in section _Managment_.

![Screenshot](./_images/azure-portal-login-with-azure-ad.png)

> Note: Since a system assigned managed identity is required the checkbox above will be checked automatically.

Would you like to enable this feature for existing machines, ensure that the VM has a system assigned identity and then add the extension manually:

1. Navigate to the Azure VM and select in the resource menu the item _Extension + applications_.
2. Click _+ Add_
3. Search for and click the tile _Azure AD based Windows Login_
4. Click _Next_, then _Review + create_ and then _Create_

After a few moments the VM is joined to Entra ID. This could be checked in the [Entra portal](https://entra.microsoft.com/#view/Microsoft_AAD_Devices/DevicesMenuBlade/~/Devices/menuId/Devices).

#### Azure CLI

Create a VM and add the extension afterwords.

```
az group create --name myResourceGroup --location southcentralus
az vm create --resource-group myResourceGroup --name myVM --image Win2019Datacenter --assign-identity --admin-username azureuser --admin-password yourpassword

az vm extension set \
    --publisher Microsoft.Azure.ActiveDirectory \
    --name AADLoginForWindows \
    --resource-group myResourceGroup \
    --vm-name myVM
```


### Sign in via RDP

## AADLogin extension for Linux

### Adding the extension for Linux

### Sign in via SSH
