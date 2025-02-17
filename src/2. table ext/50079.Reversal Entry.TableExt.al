tableextension 50079 tableextension50079 extends "Reversal Entry"
{
    fields
    {
        modify("Entry Type")
        {
            OptionCaption = ' ,G/L Account,Customer,Vendor,Bank Account,Fixed Asset,Maintenance,VAT,TDS';

            //Unsupported feature: Property Modification (OptionString) on ""Entry Type"(Field 2)".

        }
        modify("Entry No.")
        {
            TableRelation = IF ("Entry Type" = CONST("G/L Account")) "G/L Entry"
            ELSE IF ("Entry Type" = CONST(Customer)) "Cust. Ledger Entry"
            ELSE IF ("Entry Type" = CONST(Vendor)) "Vendor Ledger Entry"
            ELSE IF ("Entry Type" = CONST("Bank Account")) "Bank Account Ledger Entry"
            ELSE IF ("Entry Type" = CONST("Fixed Asset")) "FA Ledger Entry"
            ELSE IF ("Entry Type" = CONST(Maintenance)) "Maintenance Ledger Entry"
            ELSE IF ("Entry Type" = CONST(VAT)) "VAT Entry";
        }
        modify("Source No.")
        {
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset";
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 11)".

        modify("Bal. Account No.")
        {
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
    }

    //Unsupported feature: Code Modification on "InsertReversalEntry(PROCEDURE 7)".

    //procedure InsertReversalEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GLSetup.GET;
    TempReversalEntry.DELETEALL;
    NextLineNo := 1;
    #4..11
    InsertFromMaintenanceLedgEntry(Number,RevType,NextLineNo);
    InsertFromVATEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
    InsertFromGLEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
    IF TempReversalEntry.FIND('-') THEN;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14
    InsertFromTDSEntry(TempRevertTransactionNo,Number,RevType,NextLineNo);
    IF TempReversalEntry.FIND('-') THEN;
    */
    //end;


    //Unsupported feature: Code Modification on "CheckEntries(PROCEDURE 14)".

    //procedure CheckEntries();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DtldCustLedgEntry.LOCKTABLE;
    DtldVendLedgEntry.LOCKTABLE;
    GLEntry.LOCKTABLE;
    #4..6
    FALedgEntry.LOCKTABLE;
    MaintenanceLedgEntry.LOCKTABLE;
    VATEntry.LOCKTABLE;
    GLReg.LOCKTABLE;
    FAReg.LOCKTABLE;
    GLSetup.GET;
    #13..51
      REPEAT
        CheckVAT(VATEntry);
      UNTIL VATEntry.NEXT = 0;
    DateComprReg.CheckMaxDateCompressed(MaxPostingDate,1);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9
    TDSEntry.LOCKTABLE; //TDS2.00
    #10..54

    //TDS2.00
    IF TDSEntry.FIND('-') THEN
      REPEAT
        CheckTDS(TDSEntry);
      UNTIL TDSEntry.NEXT = 0;
    //TDS2.00
    DateComprReg.CheckMaxDateCompressed(MaxPostingDate,1);
    */
    //end;


    //Unsupported feature: Code Modification on "SetReverseFilter(PROCEDURE 1)".

    //procedure SetReverseFilter();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF RevType = RevType::Transaction THEN BEGIN
      GLEntry.SETCURRENTKEY("Transaction No.");
      CustLedgEntry.SETCURRENTKEY("Transaction No.");
      VendLedgEntry.SETCURRENTKEY("Transaction No.");
      BankAccLedgEntry.SETCURRENTKEY("Transaction No.");
      FALedgEntry.SETCURRENTKEY("Transaction No.");
      MaintenanceLedgEntry.SETCURRENTKEY("Transaction No.");
      VATEntry.SETCURRENTKEY("Transaction No.");
      GLEntry.SETRANGE("Transaction No.",Number);
      CustLedgEntry.SETRANGE("Transaction No.",Number);
      VendLedgEntry.SETRANGE("Transaction No.",Number);
      BankAccLedgEntry.SETRANGE("Transaction No.",Number);
      FALedgEntry.SETRANGE("Transaction No.",Number);
      MaintenanceLedgEntry.SETRANGE("Transaction No.",Number);
      VATEntry.SETRANGE("Transaction No.",Number);
    END ELSE BEGIN
      GLReg.GET(Number);
      GLEntry.SETRANGE("Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
    #19..23
      MaintenanceLedgEntry.SETCURRENTKEY("G/L Entry No.");
      MaintenanceLedgEntry.SETRANGE("G/L Entry No.",GLReg."From Entry No.",GLReg."To Entry No.");
      VATEntry.SETRANGE("Entry No.",GLReg."From VAT Entry No.",GLReg."To VAT Entry No.");
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
      TDSEntry.SETCURRENTKEY("Transaction No."); //TDS2.00
    #9..15
      TDSEntry.SETRANGE("Transaction No.",Number); //TDS2.00
    #16..26
      TDSEntry.SETRANGE("Entry No.",GLReg."From TDS Entry No.",GLReg."To TDS Entry No."); //TDS2.00
    END;
    */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: TDSEntry2) (ParameterCollection) on "CopyReverseFilters(PROCEDURE 15)".



    //Unsupported feature: Code Modification on "CopyReverseFilters(PROCEDURE 15)".

    //procedure CopyReverseFilters();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GLEntry2.COPY(GLEntry);
    CustLedgEntry2.COPY(CustLedgEntry);
    VendLedgEntry2.COPY(VendLedgEntry);
    BankAccLedgEntry2.COPY(BankAccLedgEntry);
    VATEntry2.COPY(VATEntry);
    FALedgEntry2.COPY(FALedgEntry);
    MaintenanceLedgEntry2.COPY(MaintenanceLedgEntry);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..7
    TDSEntry2.COPY(TDSEntry); //TDS2.00
    */
    //end;


    //Unsupported feature: Code Modification on "Caption(PROCEDURE 3)".

    //procedure Caption();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Entry Type" = "Entry Type"::"G/L Account" THEN BEGIN
      IF GLEntry.GET("Entry No.") THEN;
      IF GLAcc.GET(GLEntry."G/L Account No.") THEN;
    #4..29
    END;
    IF "Entry Type" = "Entry Type"::VAT THEN
      EXIT(STRSUBSTNO('%1',VATEntry.TABLECAPTION));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..32

    //TDS2.00 <<
    IF "Entry Type" = "Entry Type"::TDS THEN
      EXIT(STRSUBSTNO('%1',TDSEntry.TABLECAPTION));
    //TDS2.00 >>
    */
    //end;

    local procedure InsertFromTDSEntry(var TempRevertTransactionNo: Record Integer temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    begin
        // TDS2.00
        TempRevertTransactionNo.FINDSET;
        REPEAT
            IF RevType = RevType::Transaction THEN
                TDSEntry.SETRANGE("Transaction No.", TempRevertTransactionNo.Number);
            IF TDSEntry.FINDSET THEN
                REPEAT
                    CLEAR(TempReversalEntry);
                    IF RevType = RevType::Register THEN
                        TempReversalEntry."G/L Register No." := Number;
                    TempReversalEntry."Reversal Type" := RevType;
                    TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::TDS;
                    TempReversalEntry."Entry No." := TDSEntry."Entry No.";
                    TempReversalEntry."Posting Date" := TDSEntry."Posting Date";
                    TempReversalEntry."Source Code" := TDSEntry."Source Code";
                    TempReversalEntry."Transaction No." := TDSEntry."Transaction No.";
                    TempReversalEntry.Amount := TDSEntry."TDS Amount";
                    TempReversalEntry."Amount (LCY)" := TDSEntry."TDS Amount";
                    //TempReversalEntry."Document Type" := TDSEntry."Document Type";
                    TempReversalEntry."Document No." := TDSEntry."Document No.";
                    TempReversalEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    TempReversalEntry.INSERT;
                UNTIL TDSEntry.NEXT = 0;
        UNTIL TempRevertTransactionNo.NEXT = 0;
        // TDS2.00
    end;

    local procedure CheckTDS(TDSEntry: Record "TDS Entry")
    begin
        //TDS2.00
        /*CheckPostingDate(
          TDSEntry."Posting Date",TDSEntry.TABLECAPTION,TDSEntry.FIELDCAPTION("Entry No."),
          TDSEntry."Entry No.");
        IF TDSEntry.Closed THEN
          ERROR(
            Text006,TDSEntry.TABLECAPTION,TDSEntry."Entry No.");
        IF TDSEntry.Reversed THEN
          AlreadyReversedEntry(TDSEntry.TABLECAPTION,TDSEntry."Entry No.");
          */
        //TDS2.00

    end;

    procedure ShowTDSEntries()
    begin
        PAGE.RUN(0, TDSEntry);  //TDS2.00
    end;

    var
        TDSEntry: Record "TDS Entry";
}

