page 33020026 "LC Value Allotment"
{
    PageType = List;
    SourceTable = Table33020024;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PI Code"; "PI Code")
                {
                }
                field("Value (LCY)"; "Value (LCY)")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        CheckValue;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //Type := DocumentType;
    end;

    trigger OnOpenPage()
    begin
        /*IF GETFILTER(Type) = FORMAT(Type::Insurance) THEN
          DocumentType := DocumentType::"Letter of Credit"
        ELSE
          DocumentType := DocumentType::Insurance;
        */

    end;

    var
        DocumentType: Option Insurance,"Letter of Credit";

    [Scope('Internal')]
    procedure CheckValue()
    var
        LCDetails: Record "33020012";
        Text001: Label 'LC Allotment Sum is not equal to the LC Value.';
    begin
        LCDetails.RESET;
        LCDetails.SETRANGE("No.", "LC Code");
        IF LCDetails.FINDFIRST THEN BEGIN
            LCDetails.CALCFIELDS("Total LC Allotment");
            IF LCDetails."LC Value (LCY)" <> LCDetails."Total LC Allotment" THEN
                ERROR(Text001);
        END;
    end;
}

