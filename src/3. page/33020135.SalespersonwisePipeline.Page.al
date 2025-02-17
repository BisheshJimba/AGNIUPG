page 33020135 "Salesperson wise Pipeline"
{
    AutoSplitKey = true;
    Caption = 'Pipeline Management Details';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table33020141;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Prospect No."; "Prospect No.")
                {
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Type of Buyer"; "Type of Buyer")
                {
                }
                field("Company Name"; "Company Name")
                {
                    Caption = 'Contact Name';
                    Editable = false;
                }
                field("Contact Person"; "Contact Person")
                {
                    Editable = false;
                }
                field("Prospect Address"; "Prospect Address")
                {
                    Caption = 'Contact Address';
                    Editable = false;
                }
                field("Phone No."; "Phone No.")
                {
                    Caption = 'Phone No.';
                    Editable = false;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                    Editable = false;
                }
                field("Created Date"; "Created Date")
                {
                    Visible = false;
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                    Visible = false;
                }
                field(Purpose; Purpose)
                {
                }
                field("Vehicle Division"; "Vehicle Division")
                {
                    Visible = false;
                }
                field("Prospect Type"; "Prospect Type")
                {
                }
                field("Source of Inquiry"; "Source of Inquiry")
                {
                }
                field("Sales Progress"; "Sales Progress")
                {
                }
                field("Sales Progress Details"; "Sales Progress Details")
                {
                    Visible = false;
                }
                field("Time Line for Purchase"; "Time Line for Purchase")
                {
                }
                field("Test Drive (Y/N)"; "Test Drive (Y/N)")
                {
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    Visible = false;
                }
                field("SP Description"; "SP Description")
                {
                    Editable = false;
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Pipeline Code"; "Pipeline Code")
                {
                }
                field(Red; Red)
                {
                }
                field(Yellow; Yellow)
                {
                }
                field(Green; Green)
                {
                }
                field("Sales Quote No."; "Sales Quote No.")
                {
                }
                field("Sales Order No."; "Sales Order No.")
                {
                }
                field("Sales Invoice No."; "Sales Invoice No.")
                {
                }
                field("Lost Reason Code"; "Lost Reason Code")
                {
                    Caption = 'Lost Reason Code';
                    ToolTip = 'Reason if it is a Lost Customer';
                }
                field(Remarks; Remarks)
                {
                }
                field("Pipeline Status"; "Pipeline Status")
                {
                }
                field("Exchange Required"; "Exchange Required")
                {
                }
                field("Finance required"; "Finance required")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000002>")
            {
                Caption = 'Qualify to C0';

                trigger OnAction()
                begin

                    // CNY.CRM >>
                    Contact_G.GET("Prospect No.");

                    Contact_G.TESTFIELD(Name);
                    Contact_G.TESTFIELD(Address);

                    IF (Contact_G."Mobile Phone No." = '') AND (Contact_G."Phone No." = '') THEN
                        ERROR('Mobile / Home phone must be filled');


                    IF "Vehicle Division" = "Vehicle Division"::PCD THEN
                        Contact_G.TESTFIELD("Age bracket");

                    Contact_G.TESTFIELD(Status, Contact_G.Status::Active);

                    TESTFIELD("Salesperson Code");
                    TESTFIELD(Purpose);
                    TESTFIELD("Source of Inquiry");

                    PipelineMangDetails_G.RESET;
                    PipelineMangDetails_G.SETRANGE("Prospect No.", "Prospect No.");
                    PipelineMangDetails_G.SETRANGE("Line No.", "Line No.");
                    PipelineMangDetails_G.SETRANGE("Pipeline Code", 'F001');
                    IF PipelineMangDetails_G.FINDFIRST THEN BEGIN
                        PipelineMangDetails_G.TESTFIELD("Pipeline Status", PipelineMangDetails_G."Pipeline Status"::Open);
                        CRMMngt_G.InsertProsPipelineHistory('C0', TODAY, PipelineMangDetails_G);
                        CRMMngt_G.ChangePipelineStatus('C0', TODAY, PipelineMangDetails_G, Rec."Sales Order No.");
                        MESSAGE('Pipeline Status hasbeen changed from F001 to C0');
                    END ELSE
                        ERROR('Pipeline status should be F001');
                    // CNY.CRM <<
                end;
            }
            action("<Action1000000005>")
            {
                Caption = 'C2 Sub Stages';

                trigger OnAction()
                var
                    C2SubStage_L: Record "33020152";
                    C2SubStagePageList: Page "33020141";
                    CRMMaster_L: Record "33020143";
                begin
                    // CNY.CRM >>
                    TESTFIELD("Pipeline Status", "Pipeline Status"::Open);
                    IF "Pipeline Code" = 'C2' THEN BEGIN
                        C2SubStage_L.RESET;
                        C2SubStage_L.SETRANGE("Prospect No.", "Prospect No.");
                        C2SubStage_L.SETRANGE("Prospect Line No.", "Line No.");
                        IF NOT C2SubStage_L.FINDFIRST THEN BEGIN
                            CRMMaster_L.RESET;
                            CRMMaster_L.SETFILTER("Master Options", 'C2 Sub Stages');
                            CRMMaster_L.SETRANGE(Active, TRUE);
                            IF CRMMaster_L.FIND('-') THEN BEGIN
                                REPEAT
                                    C2SubStage_L.INIT;
                                    C2SubStage_L."Prospect No." := "Prospect No.";
                                    C2SubStage_L."Prospect Line No." := "Line No.";
                                    C2SubStage_L.Code := CRMMaster_L.Code;
                                    C2SubStage_L.Description := CRMMaster_L.Description;
                                    C2SubStage_L.Color := CRMMaster_L.Color;
                                    C2SubStage_L.Active := CRMMaster_L.Active;
                                    C2SubStage_L."Division Type" := CRMMaster_L."Division Type";
                                    C2SubStage_L.INSERT;
                                UNTIL CRMMaster_L.NEXT = 0;
                            END;
                        END;

                        C2SubStage_L.RESET;
                        C2SubStage_L.SETRANGE("Prospect No.", "Prospect No.");
                        C2SubStage_L.SETRANGE("Prospect Line No.", "Line No.");
                        C2SubStagePageList.SETRECORD(C2SubStage_L);
                        C2SubStagePageList.SETTABLEVIEW(C2SubStage_L);
                        C2SubStagePageList.EDITABLE := TRUE;
                        C2SubStagePageList.RUN;
                    END;
                    // CNY.CRM <<
                end;
            }
            group("<Action1000000038>")
            {
                Caption = 'Status';
                action("Lost prospect")
                {
                    Caption = 'Lost prospect';

                    trigger OnAction()
                    begin
                        // CNY.CRM >>

                        IF "Pipeline Status" <> "Pipeline Status"::Lost THEN BEGIN
                            IF ("Pipeline Code" = 'C3') THEN
                                ERROR('You cannot assign Lost when the prospect is in C3');

                            IF NOT CONFIRM('Are you sure you want to convert the prospect as Lost', FALSE) THEN
                                EXIT;

                            TESTFIELD("Pipeline Status", "Pipeline Status"::Open);
                            TESTFIELD("Lost Reason Code");
                            "Pipeline Status" := "Pipeline Status"::Lost;
                            MODIFY;
                            MESSAGE('Pipeline Status hasbeen changed to Lost');
                        END;

                        // CNY.CRM <<
                    end;
                }
                action("Vehicle Returned")
                {
                    Caption = 'Vehicle Returned';

                    trigger OnAction()
                    begin
                        // CNY.CRM >>

                        IF "Pipeline Status" <> "Pipeline Status"::Returned THEN BEGIN
                            IF "Pipeline Code" <> 'C3' THEN
                                ERROR('Pipeline Code should be C3');

                            IF NOT CONFIRM('Are you sure you want to convert the prospect Status as Returned', FALSE) THEN
                                EXIT;

                            TESTFIELD("Pipeline Status", "Pipeline Status"::Open);
                            TESTFIELD(Remarks);
                            "Pipeline Status" := "Pipeline Status"::Returned;
                            MODIFY;
                            MESSAGE('Pipeline Status hasbeen changed to returned');
                        END;

                        // CNY.CRM <<
                    end;
                }
                action("Returned & Considered")
                {
                    Caption = 'Returned & Considered';

                    trigger OnAction()
                    begin
                        // CNY.CRM >>

                        IF "Pipeline Status" <> "Pipeline Status"::"Returned but Considered" THEN BEGIN
                            IF "Pipeline Code" <> 'C3' THEN
                                ERROR('Pipeline Code should be C3');

                            IF NOT CONFIRM('Are you sure you want to convert the prospect Status as Returned & Considered', FALSE) THEN
                                EXIT;

                            TESTFIELD("Pipeline Status", "Pipeline Status"::Open);
                            TESTFIELD(Remarks);
                            "Pipeline Status" := "Pipeline Status"::"Returned but Considered";
                            MODIFY;
                            MESSAGE('Pipeline Status hasbeen changed to returned & Considered');
                        END;

                        // CNY.CRM <<
                    end;
                }
                action("Close Prospect")
                {
                    Caption = 'Close Prospect';

                    trigger OnAction()
                    begin
                        // CNY.CRM >>

                        IF "Pipeline Status" <> "Pipeline Status"::Closed THEN BEGIN
                            IF "Pipeline Code" <> 'C3' THEN
                                ERROR('Pipeline Code should be C3');

                            IF NOT CONFIRM('Are you sure you want to Close the prospect', FALSE) THEN
                                EXIT;

                            TESTFIELD("Pipeline Status", "Pipeline Status"::Open);
                            "Pipeline Status" := "Pipeline Status"::Closed;
                            MODIFY;
                            MESSAGE('Pipeline Status hasbeen changed to Closed');
                        END;

                        // CNY.CRM <<
                    end;
                }
            }
            action("<Action49>")
            {
                Caption = 'Interaction Log E&ntries';
                RunObject = Page 5076;
                RunPageLink = Contact Company No.=FIELD(Company No.),
                              Contact No.=FIELD(Prospect No.),
                              Prospect Line No.=FIELD(Line No.);
                RunPageView = SORTING(Contact Company No.,Contact No.);
                ShortCutKey = 'Ctrl+F7';
            }
            action("<Action1102159021>")
            {
                Caption = 'Sales Satisfaction Index';
                RunObject = Page 33020196;
                                RunPageLink = Prospect No.=FIELD(Prospect No.),
                              Prospect Line No.=FIELD(Line No.);

                trigger OnAction()
                begin
                    TESTFIELD("Pipeline Status","Pipeline Status" :: Closed);
                end;
            }
            action("Prospect Pipeline History")
            {
                Caption = 'Prospect Pipeline History';
                RunObject = Page 33020137;
                                RunPageLink = Prospect No.=FIELD(Prospect No.),
                              Prospect Line No=FIELD(Line No.);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // CNY.CRM >>

        CLEAR(Red);
        CLEAR(Yellow);
        CLEAR(Green);

        IF "Pipeline Code" = 'C2' THEN BEGIN
          C2SStage_G.RESET;
          C2SStage_G.SETRANGE("Prospect No.","Prospect No.");
          C2SStage_G.SETRANGE("Prospect Line No.","Line No.");
          C2SStage_G.SETRANGE("Division Type","Vehicle Division");
          C2SStage_G.SETRANGE(Color,'RED');
          IF C2SStage_G.FINDSET THEN BEGIN
            C2SStage_G.SETRANGE(Done,FALSE);
            IF C2SStage_G.ISEMPTY THEN
              Red := TRUE;
          END;

          C2SStage_G.RESET;
          C2SStage_G.SETRANGE("Prospect No.","Prospect No.");
          C2SStage_G.SETRANGE("Prospect Line No.","Line No.");
          C2SStage_G.SETRANGE("Division Type","Vehicle Division");
          C2SStage_G.SETRANGE(Color,'YELLOW');
          IF C2SStage_G.FINDSET THEN BEGIN
            C2SStage_G.SETRANGE(Done,FALSE);
            IF C2SStage_G.ISEMPTY THEN
              Yellow := TRUE;
          END;

          C2SStage_G.RESET;
          C2SStage_G.SETRANGE("Prospect No.","Prospect No.");
          C2SStage_G.SETRANGE("Prospect Line No.","Line No.");
          C2SStage_G.SETRANGE("Division Type","Vehicle Division");
          C2SStage_G.SETRANGE(Color,'GREEN');
          IF C2SStage_G.FINDSET THEN BEGIN
            C2SStage_G.SETRANGE(Done,FALSE);
            IF C2SStage_G.ISEMPTY THEN
              Green := TRUE;
          END;
        END;

        // CNY.CRM
    end;

    var
        "------CNY.CRM-----------------": Integer;
        PipelineMangDetails_G: Record "33020141";
        CRMMngt_G: Codeunit "33020142";
        C2SStage_G: Record "33020152";
        Contact_G: Record "5050";
}

