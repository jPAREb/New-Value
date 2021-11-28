# EN AQUESTA FUNCIÓ ENVIEM LA RUTA ON CREAR EL REGISTRE
# PER REVISAR SI CONTÉ LA RUTA ARREL (HKLM, PER EXEMPLE)
# SI LA RUTA CONTÉ AQUEST VALOR INICIAL RETORNA UN TRUE
# SINO, FALSE. D'AQUESTA MANERA CENTRALITZO LES CONSULTES
function Valor-Conte ($CadenaText, $VValor)
{
    if($CadenaText -like $VValor)
    {
        return 'True'
    }else {
        return 'False'
    }
}
# AQUESTA ES LA FUNCIÓ PRINCIPAL. QUAN REP LA DIRECCIÓ
# DEL REGISTRE QUE ES VOL CREAR, CONSULTA A VALOR-CONTE
# PER SABER SI CONTÉ EL REGISTRE ARREL. SI ESTÀ BÉ, REBEM
# UN TRUE, SINO FALSE.
# QUAN REBEM UN TRUE, CONFIRMEM QUE LA RUTA ENTRANT EX-
# ISTEIX, I ES CREA EL REGISTRE.

# EN CAS QUE LA RUTA ENTRANT NO TINGUI EL REGISTRE
# PARE, SALTA UN ERROR I UNA ADVERTÈNCIA.
# AVISANT QUÈ ÉS NECESSARI ESCRIURE L'ARREL.
# EN CAS QUE LA CARPETA NO EXISTEIXI, SALTA UN
# ERROR I UNA ADVERTÈNCIA.

function Get-ValuesType()
{
    Write-Host "1- DWORD(32 BYTES)`n2- QWORD(64 BYTES)`n3- VALOR DE CADENA`n4- VALOR BINARI`n5- VALOR DE CADENA MÚLTIPLE`n6- VALOR DE CADENA AMPLIABLE"
}
function New-Value([String]$Direccio, [String]$Nom, [char]$Informacio, [String]$TipusValor, [String]$Valor)
{
    $tipus
    if ($TipusValor -eq '1') 
    {
      $tipus = 'Dword'  
    }
    elseif ($TipusValor -eq '2') 
    {
       $tipus = 'Qword'   
    }
    elseif ($TipusValor -eq '3') 
    {
        $tipus = 'String'
    }
    elseif ($TipusValor -eq '4') 
    {
        $tipus = 'Binary'
    }
    elseif ($TipusValor -eq '5') 
    {
        $tipus = 'MultiString'
    }
    elseif ($TipusValor -eq '6') 
    {
        $tipus = 'ExpandString'
    }
    if (((Valor-Conte -CadenaText $Direccio -VValor 'HKCR:\*') -eq 'True') -or ((Valor-Conte -CadenaText $Direccio -VValor 'HKCU:\*') -eq 'True') -or ((Valor-Conte -CadenaText $Direccio -VValor 'HKLM:\*') -eq 'True') -or ((Valor-Conte -CadenaText $Direccio -VValor 'HKU:\*') -eq 'True') -or ((Valor-Conte -CadenaText $Direccio -VValor 'HKCC:\*') -eq 'True')) 
    {
        if (Test-Path -Path $Direccio) {
            try 
            {
                New-ItemProperty -Path $Direccio -name $Nom -PropertyType $tipus -Value $Valor -ErrorAction Stop | Out-Null
            }
            catch
            {
                Write-Error 'ERROR EN CREAR EL VALOR'
                Write-Host "NO S'HA POGUT CREAR EL VALOR, REVISA QUE EL VALOR NO ESTIGUI REPETIT I-O QUE TINGUIS PERMISSOS PER FER-HO." -ForegroundColor Red -BackgroundColor Black
                Break
            }
            
            if (!($Informacio -eq 'n') -or !$Informacio ) {
                Write-Host "############`n#NOU VALOR!#`n############`nNOM VALOR: $Nom`nRUTA: $Direccio`nTIPUS VALOR: $tipus" -BackgroundColor Green -ForegroundColor Black
            }
            
        }
        else
        {
            Write-Error 'LA RUTA NO EXISTEIX'
            Write-Host 'LA RUTA ESCRITA NO EXISTEIX' -ForegroundColor Red -BackgroundColor Black
        }
    }
    else 
    {
        Write-Error 'LA RUTA ESTÀ MALAMENT'
        if ((Valor-Conte -CadenaText $Direccio -VValor '.\*') -eq 'True') {
            Write-Warning "S'HA D'ESPECIFICAR LA CARPETA ARREL ('HKCR:\', 'HKCU:\', 'HKLM:\', 'HKU:\', o 'HKCC:\'). EL '.\' NO SERVEIX."
        }else {
            Write-Warning "S'HA D'ESPECIFICAR LA CARPETA ARREL ('HKCR:\', 'HKCU:\', 'HKLM:\', 'HKU:\', o 'HKCC:\')."
        }   
    }
}

#LES RUTES PARES HAN DE SER 'HKCR:\', 'HKCU:\', 'HKLM:\', 'HKU:\', o 'HKCC:\'