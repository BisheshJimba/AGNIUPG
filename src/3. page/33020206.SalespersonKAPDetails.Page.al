page 33020206 "Salesperson KAP Details"
{
    PageType = List;
    SourceTable = Table33020200;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field(Year; Year)
                {
                }
                field(Month; Month)
                {
                }
                field("Week No"; "Week No")
                {
                }
                field(Make; Make)
                {
                }
                field("Model No."; "Model No.")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
                field("Model Version Name"; "Model Version Name")
                {
                    Visible = false;
                }
                field(Activity; Activity)
                {
                }
                field("What to do"; "What to do")
                {
                }
                field("Target C0"; "Target C0")
                {
                }
                field("Target C1"; "Target C1")
                {
                }
                field("Target C2"; "Target C2")
                {
                }
                field("Target C3"; "Target C3")
                {
                }
                field("By When"; "By When")
                {
                }
                field("Strategy (Monitorable Param)"; "Strategy (Monitorable Param)")
                {
                }
                field("Achieved C0"; "Achieved C0")
                {
                }
                field("Achieved C1"; "Achieved C1")
                {
                }
                field("Achieved C2"; "Achieved C2")
                {
                }
                field("Achieved C3"; "Achieved C3")
                {
                }
                field("RS of Activity"; "RS of Activity")
                {
                }
                field("KAP Status"; "KAP Status")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("<Action1000000008>")
            {
                Caption = 'Status';
                action(Done)
                {
                    Caption = 'Done';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF "KAP Status" <> "KAP Status"::Done THEN BEGIN
                            IF NOT CONFIRM('Are you sure you want to convert the kap status to done?', FALSE) THEN
                                EXIT;
                            "KAP Status" := "KAP Status"::Done;
                            MODIFY;
                            MESSAGE('KAP Status habeen changed to Done');
                        END;
                    end;
                }
                action("Not Done")
                {
                    Caption = 'Not Done';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF "KAP Status" <> "KAP Status"::"Not Done" THEN BEGIN
                            IF NOT CONFIRM('Are you sure you want to convert the kap status to not done?', FALSE) THEN
                                EXIT;

                            TESTFIELD("RS of Activity");
                            "KAP Status" := "KAP Status"::"Not Done";
                            MODIFY;
                            MESSAGE('KAP Status habeen changed to Not Done');
                        END;
                    end;
                }
                action("<Action1000000011>")
                {
                    Caption = 'Postponed';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF "KAP Status" <> "KAP Status"::Postponed THEN BEGIN
                            IF NOT CONFIRM('Are you sure you want to convert the kap status to postponed?', FALSE) THEN
                                EXIT;

                            TESTFIELD("RS of Activity");
                            "KAP Status" := "KAP Status"::Postponed;
                            MODIFY;
                            MESSAGE('KAP Status habeen changed to Postponed');
                        END;
                    end;
                }
            }
        }
    }
}

