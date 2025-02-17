tableextension 50031 tableextension50031 extends "Payment Application Proposal"
{
    fields
    {
        modify("Statement No.")
        {
            TableRelation = "Bank Acc. Reconciliation"."Statement No." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                              "Statement Type" = FIELD("Statement Type"));
        }
        modify("Account No.")
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(false))
            ELSE IF ("Account Type" = CONST(Customer)) Customer
            ELSE IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        modify("Applies-to Entry No.")
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Entry"
            ELSE IF ("Account Type" = CONST(Customer)) "Cust. Ledger Entry" WHERE(Open = CONST(true))
            ELSE IF ("Account Type" = CONST(Vendor)) "Vendor Ledger Entry" WHERE(Open = CONST(true))
            ELSE IF ("Account Type" = CONST("Bank Account")) "Bank Account Ledger Entry" WHERE(Open = CONST(true));
        }
    }
}

