page 25006181 "Vehicle Service Plan Stages"
{
    Caption = 'Vehicle Service Plan Stages';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006132;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("Plan No."; "Plan No.")
                {
                    Visible = false;
                }
                field(Recurrence; Recurrence)
                {
                    Visible = false;
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Kilometrage; Kilometrage)
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("VF Initial Run 1"; "VF Initial Run 1")
                {
                    Visible = false;
                }
                field("VF Initial Run 2"; "VF Initial Run 2")
                {
                    Visible = false;
                }
                field("VF Initial Run 3"; "VF Initial Run 3")
                {
                    Visible = false;
                }
                field("Service Date"; "Service Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Expected Service Date"; "Expected Service Date")
                {
                }
                field("Service Interval"; "Service Interval")
                {
                }
                field("Package No."; "Package No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Stage)
            {
                Caption = 'Stage';
                action("Document Link")
                {
                    Caption = 'Document Link';
                    Image = Document;
                    RunObject = Page 25006222;
                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                  Serv. Plan No.=FIELD(Plan No.),
                                  Serv. Plan Stage Code=FIELD(Code),
                                  Plan Stage Recurrence=FIELD(Recurrence);
                }
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page 25006248;
                                    RunPageLink = Type=CONST(Plan Stage),
                                  Plan No.=FIELD(Plan No.),
                                  Stage Code=FIELD(Code),
                                  Vehicle Serial No.=FIELD(Vehicle Serial No.);
                    RunPageView = SORTING(Type,Plan No.,Stage Code,Vehicle Serial No.,Line No.);
                }
            }
        }
    }
}

