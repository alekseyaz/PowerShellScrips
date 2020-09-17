[string] $certPath = 'c:\tmp\onelocalhost.pfx';
[string] $certPass = '12345';

# Create a collection object and populate it using the PFX file
$collection = [System.Security.Cryptography.X509Certificates.X509Certificate2Collection]::new();
$collection.Import($certPath, $certPass,  [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet);

try {
    # Open the Store My/Personal
    $store = [System.Security.Cryptography.X509Certificates.X509Store]::new('My');
    $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite);

    foreach ($cert in $collection) {
        Write-Host ("Subject is: '{0}'" -f  $cert.Subject  )
        Write-Host ("Issuer is:  '{0}'" -f  $cert.Issuer  )

        # Import the certificate into an X509Store object
        # source https://support.microsoft.com/en-au/help/950090/installing-a-pfx-file-using-x509certificate-from-a-standard-net-applic

        if ($cert.Thumbprint -in @($store.Certificates | % { $_.Thumbprint } )) {
            Write-Warning "Certificate is already in the store"
            # Force the removal of the certificate so we have no conflicts, not required if this is the first install    
            $store.Remove($cert)
        }
        # Add in the certificate 
        $store.Add($cert);
    }
} finally {
    if($store) {
        # Dispose of the store once we are done
        $store.Dispose()
    }
}