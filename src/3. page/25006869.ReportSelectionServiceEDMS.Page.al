page 25006869 "Report Selection - ServiceEDMS"
{
    Caption = 'Report Selection - Service EDMS';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = Table77;

    layout
    {
        area(content)
        {
            field(ReportUsage2; ReportUsage2)
            {
                Caption = 'Usage';
                OptionCaption = 'Invoice,Credit Memo';

                trigger OnValidate()
                begin
                    SetUsageFilter;
                    ReportUsage2OnAfterValidate;
                end;
            }
            repeater()
            {
                field(Sequence; Sequence)
                {
                }
                field("Report ID"; "Report ID")
                {
                    LookupPageID = Objects;
                }
                field("Report Caption"; "Report Caption")
                {
                    DrillDown = false;
                    LookupPageID = Objects;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        ReportUsage2 := ReportUsage2::Invoice;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewRecord;
    end;

    trigger OnOpenPage()
    begin
        SetUsageFilter;
    end;

    var
        ReportUsage2: Option Invoice,"Credit Memo";

    local procedure SetUsageFilter()
    begin
        FILTERGROUP(2);
        CASE ReportUsage2 OF
            ReportUsage2::Invoice:
                SETRANGE(Usage, Usage::"Pst.Serv.Inv.Edms");
            ReportUsage2::"Credit Memo":
                SETRANGE(Usage, Usage::"Pst.Serv.Cr.M.Edms");
        END;
        FILTERGROUP(0);
    end;

    local procedure ReportUsage2OnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

