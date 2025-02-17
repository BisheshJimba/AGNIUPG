tableextension 50537 tableextension50537 extends "Comment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Table Name=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Table Name=CONST(Customer)) Customer
                            ELSE IF (Table Name=CONST(Vendor)) Vendor
                            ELSE IF (Table Name=CONST(Item)) Item
                            ELSE IF (Table Name=CONST(Resource)) Resource
                            ELSE IF (Table Name=CONST(Job)) Job
                            ELSE IF (Table Name=CONST(Resource Group)) "Resource Group"
                            ELSE IF (Table Name=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Table Name=CONST(Campaign)) Campaign
                            ELSE IF (Table Name=CONST(Fixed Asset)) "Fixed Asset"
                            ELSE IF (Table Name=CONST(Insurance)) Insurance
                            ELSE IF (Table Name=CONST(IC Partner)) "IC Partner";
        }
    }
}

