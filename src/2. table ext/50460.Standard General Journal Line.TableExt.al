tableextension 50460 tableextension50460 extends "Standard General Journal Line"
{
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Account Type=CONST(Customer)) Customer
                            ELSE IF (Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                            ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
        }
        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset"
                            ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner";
        }
        modify("Bill-to/Pay-to No.")
        {
            TableRelation = IF (Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;
        }
        modify("Posting Group")
        {
            TableRelation = IF (Account Type=CONST(Customer)) "Customer Posting Group"
                            ELSE IF (Account Type=CONST(Vendor)) "Vendor Posting Group"
                            ELSE IF (Account Type=CONST(Fixed Asset)) "FA Posting Group";
        }
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Source Type=CONST(Fixed Asset)) "Fixed Asset";
        }
        modify("Ship-to/Order Address Code")
        {
            TableRelation = IF (Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Bal. Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Bal. Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.));
        }
        modify("Sell-to/Buy-from No.")
        {
            TableRelation = IF (Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;
        }
    }
}

