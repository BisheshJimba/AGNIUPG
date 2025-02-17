page 33020562 "Base Calendar Card PRM"
{
    Caption = 'Base Calendar Card PRM';
    PageType = ListPlus;
    SourceTable = Table33020560;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
            part(BaseCalendarEntries; 33020565)
            {
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
                        CalendarMgt: Codeunit "7600";
                        WhereUsedList: Page "7608";
                    begin
                        CalendarMgt.CreateWhereUsedEntries(Code);
                        WhereUsedList.RUNMODAL;
                        CLEAR(WhereUsedList);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Maintain Base Calendar Changes")
                {
                    Caption = '&Maintain Base Calendar Changes';
                    RunObject = Page 33020564;
                    RunPageLink = Base Calendar Code=FIELD(Code);
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.BaseCalendarEntries.PAGE.SetCalendarCode(Code);
    end;
}

