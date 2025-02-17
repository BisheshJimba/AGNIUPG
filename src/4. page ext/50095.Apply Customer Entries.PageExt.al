pageextension 50095 pageextension50095 extends "Apply Customer Entries"
{
    layout
    {
        addafter("Control 56")
        {
            field("VF Posting Type"; "VF Posting Type")
            {
            }
            field("Loan File No."; "Loan File No.")
            {
            }
        }
    }


    //Unsupported feature: Property Modification (OptionString) on "CalcType(Variable 1029)".

    //var
    //>>>> ORIGINAL VALUE:
    //CalcType : Direct,GenJnlLine,SalesHeader,ServHeader;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //CalcType : Direct,GenJnlLine,SalesHeader,ServHeader,ServHeaderEDMS;
    //Variable type has not been exported.

    var
        ServHeaderEDMS: Record "25006145";
        TotalServLineEDMS: Record "25006146";
        TotalServLineLCYEDMS: Record "25006146";
        ServicePost: Codeunit "25006101";

    procedure SetServiceEDMS(NewServHeader: Record "25006145"; var NewCustLedgEntry: Record "21"; ApplnTypeSelect: Integer)
    var
        TotalAdjCostLCY: Decimal;
    begin
        ServHeaderEDMS := NewServHeader;
        Rec.COPYFILTERS(NewCustLedgEntry);

        ServicePost.SumServiceLines2(
          ServHeaderEDMS, 0, TotalServLineEDMS, TotalServLineLCYEDMS,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);

        CASE ServHeaderEDMS."Document Type" OF
            ServHeaderEDMS."Document Type"::"Return Order":
                ApplyingAmount := -TotalServLineEDMS."Amount Including VAT"
            ELSE
                ApplyingAmount := TotalServLineEDMS."Amount Including VAT";
        END;

        ApplnDate := ServHeaderEDMS."Posting Date";
        ApplnCurrencyCode := ServHeaderEDMS."Currency Code";
        CalcType := CalcType::ServHeaderEDMS;

        CASE ApplnTypeSelect OF
            ServHeaderEDMS.FIELDNO("Applies-to Doc. No."):
                ApplnType := ApplnType::"Applies-to Doc. No.";
        END;

        SetApplyingCustLedgEntry;
    end;
}

