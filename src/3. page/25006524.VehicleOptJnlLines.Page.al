page 25006524 "Vehicle Opt. Jnl. Lines"
{
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Journal Lines';
    Editable = false;
    PageType = List;
    SourceTable = Table25006387;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Journal Template Name"; "Journal Template Name")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Option Type"; "Option Type")
                {
                }
                field("Option Code"; "Option Code")
                {
                }
                field("External Code"; "External Code")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field(Standard; Standard)
                {
                }
                field("Option Subtype"; "Option Subtype")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("Show Batch")
                {
                    Caption = 'Show Batch';
                    Image = Description;

                    trigger OnAction()
                    begin
                        recVehOptJnlTemplate.GET("Journal Template Name");
                        recVehOptJnlLine := Rec;
                        recVehOptJnlLine.FILTERGROUP(2);
                        recVehOptJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                        recVehOptJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                        recVehOptJnlLine.FILTERGROUP(0);
                        PAGE.RUN(recVehOptJnlTemplate."Form ID", recVehOptJnlLine);
                    end;
                }
            }
        }
    }

    var
        recVehOptJnlLine: Record "25006387";
        recVehOptJnlTemplate: Record "25006385";
}

