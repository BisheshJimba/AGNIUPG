tableextension 50139 tableextension50139 extends "Reminder Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Line Fee)) "G/L Account";
        }
    }

    //Unsupported feature: Code Modification on "CalcFinChrg(PROCEDURE 6)".

    //procedure CalcFinChrg();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetReminderHeader;
    "Interest Rate" := 0;
    Amount := 0;
    #4..44
              DtldCLE."Entry Type"::"Initial Entry",
              DtldCLE."Entry Type"::Application,
              DtldCLE."Entry Type"::"Payment Tolerance",
              DtldCLE."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
              DtldCLE."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)");
            DtldCLE.SETRANGE("Posting Date",0D,ReminderHeader."Document Date");
            IF DtldCLE.FIND('-') THEN
              REPEAT
    #53..85
      VALIDATE("Gen. Prod. Posting Group",GLAcc."Gen. Prod. Posting Group");
      VALIDATE("VAT Prod. Posting Group",GLAcc."VAT Prod. Posting Group");
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..47
              DtldCLE."Entry Type"::"Payment Tolerance (VAT Adjustment)",
              DtldCLE."Entry Type"::"Payment Discount Tolerance (VAT Excl.)");
    #50..88
    */
    //end;
}

