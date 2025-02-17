page 33020134 "Outstanding by Sales/Cr. Offic"
{
    Caption = 'Outstanding by Sales/Cr. Officer';
    PageType = ListPart;
    SourceTable = Table13;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Outstanding Cr Amt"; "Outstanding Cr Amt")
                {
                    DrillDownPageID = "Approved Vehicle Finance List";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        //"Outstanding Cr Amt" :=GetOutstandingCreditAmount(Code);
    end;

    trigger OnAfterGetRecord()
    begin
        //"Outstanding Cr Amt" :=GetOutstandingCreditAmount(Code);
    end;

    local procedure GetOutstandingCreditAmount(SalesPersonCode: Code[20]): Decimal
    var
        VFHeader: Record "33020062";
    begin
        VFHeader.RESET;
        VFHeader.SETRANGE(Closed, FALSE);
        VFHeader.SETRANGE("Loan Disbursed", TRUE);
        VFHeader.SETRANGE(Rejected, FALSE);
        VFHeader.SETRANGE("Responsible Person Code", SalesPersonCode);
        VFHeader.CALCSUMS("Total Due as of Today");
        EXIT(VFHeader."Total Due as of Today");
    end;
}

