tableextension 50126 tableextension50126 extends "Bank Account Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
        }
        modify("Statement Line No.")
        {
            TableRelation = "Bank Acc. Reconciliation Line"."Statement Line No." WHERE (Bank Account No.=FIELD(Bank Account No.),
                                                                                        Statement No.=FIELD(Statement No.));
        }
        field(50000;"Cheque No.";Code[30])
        {
        }
        field(50001;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No';
        }
        field(50002;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(50003;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                tcAMT001: Label 'This VIN is being used in %1! Are you shore that you want to use exactly this VIN?';
                tcAMT002: Label 'Serial No. in Vehicle table differs from Serial No. in Sales Line!';
            begin
            end;
        }
        field(50004;"Document Class";Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account';
            OptionMembers = " ",Customer,Vendor,"Bank Account";
        }
        field(50005;"Document Subclass";Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account";
        }
        field(50006;"VF Loan File No.";Code[20])
        {
            TableRelation = "Vehicle Finance Header"."Loan No.";
        }
        field(50007;"VF Customer Name";Text[70])
        {
            CalcFormula = Lookup("Vehicle Finance Header"."Customer Name" WHERE (Loan No.=FIELD(VF Loan File No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008;"Created by";Code[50])
        {
            Editable = false;
        }
        field(50099;"Sales Invoice No.";Code[20])
        {
            TableRelation = "Sales Invoice Header".No.;
        }
        field(33020011;"System LC No.";Code[20])
        {
            Caption = 'LC No.';
        }
        field(33020012;"Bank LC No.";Code[20])
        {
        }
        field(33020013;"LC Amend No.";Code[20])
        {
        }
        field(33020062;"VF Posting Type";Option)
        {
            OptionCaption = ' ,Principal,Interest,Penalty,Service Charge,Insurance,Other Charges';
            OptionMembers = " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges";
        }
        field(33020065;Narration;Text[250])
        {
        }
    }
    keys
    {

        //Unsupported feature: Property Deletion (Enabled) on ""Bank Account No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date"(Key)".

        key(Key1;"Document Date")
        {
        }
    }


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 3)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Bank Account No." := GenJnlLine."Account No.";
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        #4..15
        "User ID" := USERID;
        "Bal. Account Type" := GenJnlLine."Bal. Account Type";
        "Bal. Account No." := GenJnlLine."Bal. Account No.";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..18

        Narration := GenJnlLine.Narration;
        "Sales Invoice No." := GenJnlLine."Sales Invoice No.";

        "Cheque No." := GenJnlLine."Cheque No."; //Added on 18 Jan 2012.
        "Document Class" := GenJnlLine."Document Class";
        "Document Subclass" := GenJnlLine."Document Subclass";
        "Created by" := GenJnlLine."Created by";
        //--dms fields
        "Vehicle Serial No." := GenJnlLine."Vehicle Serial No.";
        "Vehicle Accounting Cycle No." := GenJnlLine."Vehicle Accounting Cycle No.";
        VIN := VIN;

        //--vehicle finance
        "VF Posting Type" := GenJnlLine."VF Posting Type";
        "VF Loan File No."  := GenJnlLine."VF Loan File No.";
        //--

        //LC6.1.0 - Added for LC Tracking.
        "System LC No." := GenJnlLine."Sys. LC No.";
        */
    //end;
}

