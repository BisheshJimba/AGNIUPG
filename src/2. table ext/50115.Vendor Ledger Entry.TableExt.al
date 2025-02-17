tableextension 50115 tableextension50115 extends "Vendor Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".


        //Unsupported feature: Property Modification (CalcFormula) on "Amount(Field 13)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Remaining Amount"(Field 14)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Original Amt. (LCY)"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Remaining Amt. (LCY)"(Field 16)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amount (LCY)"(Field 17)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal.Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount"(Field 58)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount"(Field 59)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount (LCY)"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount (LCY)"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Original Amount"(Field 75)".

        field(50000;VIN;Code[20])
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
        field(50001;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No';
            Editable = false;
        }
        field(50002;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(50003;"Document Class";Option)
        {
            Caption = 'Document Class';
            Editable = false;
            OptionCaption = ' ,Customer,Vendor,Bank Account';
            OptionMembers = " ",Customer,Vendor,"Bank Account";
        }
        field(50004;"Document Subclass";Code[20])
        {
            Caption = 'Document Subclass';
            Editable = false;
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account";
        }
        field(50006;"Created by";Code[50])
        {
            Editable = false;
        }
        field(59003;"TDS Amount";Decimal)
        {
        }
        field(33020065;Narration;Text[250])
        {
            Editable = false;
        }
        field(33020244;"Debit Note No.";Code[20])
        {
        }
        field(33020245;"Credit Note No.";Code[20])
        {
        }
        field(33020246;"Service Order No.";Code[20])
        {
            Description = 'Used for External Service Order';
            TableRelation = "Posted Serv. Order Header";
            ValidateTableRelation = false;
        }
        field(33020247;"VAT Registration No.";Text[30])
        {
        }
    }
    keys
    {
        key(Key1;"Document No.","Posting Date")
        {
        }
        key(Key2;"Posting Date")
        {
        }
        key(Key3;"Global Dimension 1 Code")
        {
        }
        key(Key4;"Document Date")
        {
        }
    }


    //Unsupported feature: Code Modification on "ShowDoc(PROCEDURE 7)".

    //procedure ShowDoc();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CASE "Document Type" OF
          "Document Type"::Invoice:
            IF PurchInvHeader.GET("Document No.") THEN BEGIN
              PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
              EXIT(TRUE);
            END;
          "Document Type"::"Credit Memo":
            IF PurchCrMemoHdr.GET("Document No.") THEN BEGIN
              PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
              EXIT(TRUE);
            END
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8
              PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHdr);
        #10..12
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromGenJnlLine(PROCEDURE 6)".

    //procedure CopyFromGenJnlLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Vendor No." := GenJnlLine."Account No.";
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        #4..35
        "Payment Reference" := GenJnlLine."Payment Reference";
        "Payment Method Code" := GenJnlLine."Payment Method Code";
        "Exported to Payment File" := GenJnlLine."Exported to Payment File";

        OnAfterCopyVendLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..38
        Narration := GenJnlLine.Narration;
        "Service Order No." := GenJnlLine."Service Order No.";

        //document class and subclass
        "Document Class" := GenJnlLine."Document Class";
        "Document Subclass" := GenJnlLine."Document Subclass";
        //--dms fields
        "Vehicle Serial No." := GenJnlLine."Vehicle Serial No.";
        "Vehicle Accounting Cycle No." := GenJnlLine."Vehicle Accounting Cycle No.";
        VIN := GenJnlLine.VIN;

        OnAfterCopyVendLedgerEntryFromGenJnlLine(Rec,GenJnlLine);
        */
    //end;
}

