page 33020051 "Accountability Center List"
{
    Caption = 'Accountability Center List';
    CardPageID = "Accountability Center Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33019846;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Location Code"; "Location Code")
                {
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
        area(navigation)
        {
            group("&Resp. Ctr.")
            {
                Caption = '&Resp. Ctr.';
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page 540;
                        RunPageLink = Table ID=CONST(5714),
                                      No.=FIELD(Code);
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData 348=R;
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            GLAcc: Record "15";
                            DefaultDimMultiple: Page "542";
                        begin
                            CurrPage.SETSELECTIONFILTER(GLAcc);
                            DefaultDimMultiple.SetMultiGLAcc(GLAcc);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
            }
        }
    }
}

