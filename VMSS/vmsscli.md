__Display VM Scaleset Instance Information__
```bash
    myResourceGroup="azVMSS-01"
    myScaleSet="vmscaleset"
    
    az vmss list-instances \
    --resource-group $myResourceGroup \
    --name $myScaleSet \
    --output table
```

>To view additional information about a specific VM instance, add the --instance-id parameter to az vmss get-instance-view. 
```bash
    az vmss get-instance-view \
    --resource-group $myResourceGroup \
    --name $myScaleSet \
    --instance-id 0
```

