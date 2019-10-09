Get-AzContext

$path = read-host "coloca una direccion en tu equipo"  

Add-Content -Path  $path  -Value '"Subscripcion","nombre","Grupo de recursos"'

$Sub = read-host "coloca la clave de tu subscripcion"

foreach($Sub in $Subs)
{
 Set-AzContext -SubscriptionId $Sub.Id

$nsgs=Get-AzNetworkSecurityGroup

    foreach($nsg in $nsgs){

    $usado=$nsg.Subnets.Id

    if($usado -Eq $NULL )
        { 
        
            $usado=$nsg.NetworkInterfaces.Id  
                if($usado -eq $NULL )
                {
                $nombre = $nsg.Name
                $rg= $nsg.ResourceGroupName  
                $Subname=$Sub.Name
                $out = @(" $Subname, $nombre ,$rg" ) 
                $out | foreach { Add-Content -Path $path -Value $_ }
                }
        }  

    }
}

