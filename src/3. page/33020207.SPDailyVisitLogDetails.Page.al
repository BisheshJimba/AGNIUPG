page 33020207 "SP Daily Visit Log Details"
{
    PageType = List;
    SourceTable = Table33020201;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prospect No."; "Prospect No.")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Salesperson Code" := xRec."Salesperson Code";
        Year := xRec.Year;
        "Week No" := xRec."Week No";
        Date := xRec.Date;
    end;
}

