Connect-AzureRmAccount

Get-AzureRmContext

 #coloca aqui el id de tu subscripción

#NIC sin usar
$path = read-host "coloca una direccion en tu equipo"  

$path=$path+"\limpieza.csv"


$Subx = read-host "coloca el ID clave de tu subscripcion"

Set-AzureRmContext -SubscriptionId $Subx

Add-Content -Path  $path  -Value '"ID","Nombre","tipoderecurso","IDtipo","grupoderecurso","sku","next"'

$nics = get-azurermnetworkinterface | where VirtualMachine -Eq $null

foreach($nic in $nics)
   {
   $nicname = $nic.Name
   $rg = $nic.ResourceGroupName
   $employees = @(" $nicname, $rg, interface de red" ) 
   $employees | foreach { Add-Content -Path $path -Value $_ }
}

##IP pública sin alocar

$ips=Get-AzureRmPublicIpAddress | where IpAddress -Eq "Not Assigned"

foreach($ip in $ips)
   {
   $ipname = $ip.Name
   $rg = $ip.ResourceGroupName
   $employees = @(" $ipname, $rg, ippublica" ) 
   $employees | foreach { Add-Content -Path $path -Value $_ }
}

##Grupo de recursos vacio

$rgs=Get-AzureRmResourceGroup


foreach($rg in $rgs)
{
$find=Find-AzureRmResource -ResourceGroupName $rg.ResourceGroupName
if($find.count -eq 0)
   {
    $employees = @(" $($rg.ResourceGroupName), $($find.count), resourcegroup" ) 
    $employees | foreach { Add-Content -Path $path -Value $_ }
   } 
}

#Máquinas virtuales no alocadas o fallidas


Add-Content -Path  $path  -Value '"Nombre","grupoderecursos","estado"'

 $RGs = Get-AzureRMResourceGroup
 foreach($RG in $RGs)
 {
   $VMs = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName
   foreach($VM in $VMs)
   {
     $VMDetail = Get-AzureRmVM -ResourceGroupName $RG.ResourceGroupName -Name $VM.Name -Status
     $RGN = $VMDetail.ResourceGroupName  
     foreach ($VMStatus in $VMDetail.Statuses)
     { 
         $VMStatusDetail = $VMStatus.DisplayStatus
         if($VMStatusDetail -ne "VM running")
         {
         $employees = @("$($VM.Name), $($Rg.ResourceGroupName), $VMStatusDetail" ) 
    $employees | foreach { Add-Content -Path $path -Value $_ }

         }
     }
     
     
         }
 }

