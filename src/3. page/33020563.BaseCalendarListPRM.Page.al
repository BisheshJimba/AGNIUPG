page 33020563 "Base Calendar List PRM"
{
    Caption = 'Base Calendar List PRM';
    CardPageID = "Base Calendar Card PRM";
    Editable = false;
    PageType = List;
    SourceTable = Table33020560;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                    Caption = 'Code';
                }
                field(Name; Name)
                {
                }
                field("Customized Changes Exist"; "Customized Changes Exist")
                {
                    Caption = 'Customized Changes Exist';
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
            group("&Base Calendar")
            {
                Caption = '&Base Calendar';
                action("&Where-Used List")
                {
                    Caption = '&Where-Used List';

                    trigger OnAction()
                    var
                        CalendarMgmt: Codeunit "7600";
                        WhereUsedList: Page "7608";
                    begin
                        CalendarMgmt.CreateWhereUsedEntries(Code);
                        WhereUsedList.RUNMODAL;
                        CLEAR(WhereUsedList);
                    end;
                }
                separator("-")
                {
                    Caption = '-';
                }
                action("&Base Calendar Changes")
                {
                    Caption = '&Base Calendar Changes';
                    RunObject = Page 7607;
                    RunPageLink = Base Calendar Code=FIELD(Code);
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;
}

