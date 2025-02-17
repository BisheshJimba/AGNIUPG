page 25006180 "Vehicle Service Plans"
{
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009

    Caption = 'Vehicle Service Plans';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006126;

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
                field("Template Code"; "Template Code")
                {
                    Visible = false;
                }
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Description)
                {
                }
                field(Active; Active)
                {
                }
                field(VIN; VIN)
                {
                    Visible = false;
                }
                field("Service Plan Type"; "Service Plan Type")
                {
                }
                field("Start Variable Field Run 1"; "Start Variable Field Run 1")
                {
                    Visible = false;
                }
                field("Start Variable Field Run 2"; "Start Variable Field Run 2")
                {
                    Visible = false;
                }
                field("Start Variable Field Run 3"; "Start Variable Field Run 3")
                {
                    Visible = false;
                }
                field("Start Date"; "Start Date")
                {
                    Visible = false;
                }
                field("Creation Date"; "Creation Date")
                {
                    Visible = false;
                }
                field(Adjust; Adjust)
                {
                    Visible = false;
                }
                field(Recurring; Recurring)
                {
                    Visible = false;
                }
                field("Auto Order By Exp. Date"; "Auto Order By Exp. Date")
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
            group(Plan)
            {
                Caption = 'Plan';
                action(Stages)
                {
                    Caption = 'Stages';
                    Ellipsis = true;
                    Image = Stages;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006181;
                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                  Plan No.=FIELD(No.);
                }
                action("Document Link")
                {
                    Caption = 'Document Link';
                    Image = Document;
                    RunObject = Page 25006222;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                  Serv. Plan No.=FIELD(No.);
                }
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page 25006248;
                                    RunPageLink = Type=CONST(Plan),
                                  Plan No.=FIELD(No.),
                                  Vehicle Serial No.=FIELD(Vehicle Serial No.);
                }
                action("Change Log")
                {
                    Caption = 'Change Log';
                    Image = ChangeLog;
                    RunObject = Page 25006284;
                                    RunPageLink = Table No.=CONST(25006132),
                                  Primary Key Field 1 Value=FIELD(Vehicle Serial No.),
                                  Primary Key Field 2 Value=FIELD(No.);
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("Apply Template")
                {
                    Caption = 'Apply Template';
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ServicePlanMgt: Codeunit "25006103";
                    begin
                        ServicePlanMgt.ApplyTemplate(Rec);
                    end;
                }
                action("Calc. Expected Service Dates")
                {
                    Caption = 'Calc. Expected Service Dates';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        REPORT.RUN(REPORT::"Calc. Expected Service Dates", TRUE, FALSE, Rec)
                    end;
                }
                action("Plan Change")
                {
                    Caption = 'Plan Change';
                    Image = Change;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        VehicleServicePlan: Record "25006126";
                    begin
                        IF "No." <> '' THEN BEGIN
                          VehicleServicePlan.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
                          VehicleServicePlan.SETRANGE("No.", "No.");
                          REPORT.RUN(REPORT::"Service Plan Change", TRUE, FALSE, VehicleServicePlan);
                          CurrPage.UPDATE;
                        END;
                    end;
                }
            }
        }
    }
}

