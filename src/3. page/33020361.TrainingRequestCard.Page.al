page 33020361 "Training Request Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table33020359;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = isComplete;
                field("Tr. Req. No."; "Tr. Req. No.")
                {
                    Editable = FieldEditable;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Department; Department)
                {
                    Editable = FieldEditable;
                }
                field("Training Code"; "Training Code")
                {
                    Editable = FieldEditable;

                    trigger OnValidate()
                    begin
                        TrainingList.SETRANGE("Training Code", "Training Code");
                        IF TrainingList.FIND('-') THEN
                            "Training Topic" := TrainingList."Training Topic";

                        //TrainingRequestsLineRec.RESET;
                    end;
                }
                field("Training Topic"; "Training Topic")
                {
                    Editable = false;
                }
                field("Training Objective"; "Training Objective")
                {
                    Editable = FieldEditable;
                }
                field("From Date"; "From Date")
                {
                    Editable = FieldEditable;
                }
                field("To Date"; "To Date")
                {
                    Editable = FieldEditable;
                }
                field("Duration (days)"; "Duration (days)")
                {
                    Editable = FieldEditable;
                }
                field(ODT; ODT)
                {
                    Editable = FieldEditable;
                }
                field("Requested By"; "Requested By")
                {
                    Editable = FieldEditable;
                }
                field("Requested Name"; "Requested Name")
                {
                    Editable = false;
                }
                field(Cost; Cost)
                {
                    Editable = FieldEditable;
                }
                field(Institute; Institute)
                {
                    Editable = FieldEditable;
                }
                field(Venue; Venue)
                {
                    Editable = FieldEditable;
                }
            }
            part(; 33020362)
            {
                Editable = FieldEditable;
                SubPageLink = Tr. Req. No.=FIELD(Tr. Req. No.);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102159019>")
            {
                Caption = 'Function(s)';
                action(SendAppReq)
                {
                    Caption = 'Send Approval Request';
                    Image = Export;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    var
                        LclDocType: Integer;
                    begin
                        //Call function to send approval request.
                        TESTFIELD("Training Code");
                        TESTFIELD("Training Objective");
                        TESTFIELD("From Date");
                        TESTFIELD("To Date");
                        TESTFIELD("Training Topic");
                        IF NOT Approved THEN BEGIN
                            GblDocAppMngt.sendAppReqHRTraining(DATABASE::"Training Requests Header", GblDocType::HR, "Tr. Req. No.");
                        END;
                    end;
                }
                action(CanAppReq)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Reject;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = false;

                    trigger OnAction()
                    begin
                        //Call function to cancel approval request.
                        IF NOT Canceled THEN BEGIN
                            GblDocAppMngt.CancelAppReqHRTraining(DATABASE::"Training Requests Header", GblDocType::HR, "Tr. Req. No.");
                        END;
                    end;
                }
                action("Employee Training From Appraisal")
                {
                    Caption = 'Employee Training From Appraisal';
                    Image = ExportSalesPerson;
                    RunObject = Page 33020460;
                    RunPageLink = Training Code=FIELD(Training Code);
                    Visible = false;
                }
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = approvalSent;

                    trigger OnAction()
                    var
                        DocNotificationMgt: Codeunit "33019917";
                    begin
                        IF "Requested By" <> USERID THEN BEGIN
                          //ConfirmApprove := DIALOG.CONFIRM(Text002,FALSE);
                          //IF ConfirmApprove THEN BEGIN
                          IF DocNotificationMgt.verifyApprover(Rec) <> USERID THEN
                            ERROR('You are not the approver.');

                              Approved := TRUE;
                              Rejected := FALSE;
                              VALIDATE("Approved Date",TODAY);
                              "Approved By" := USERID;
                              MODIFY;
                              DocNotificationMgt.SendTrainingApprovedMailtoEmployee(Rec);  //SRT Feb 7th 2019


                         END ELSE BEGIN
                            MESSAGE('Approver must be different.');
                          END ;
                    end;
                }
                action(Disapprove)
                {
                    Caption = 'Disapprove';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = approvalSent;

                    trigger OnAction()
                    var
                        DocNotificationMgt: Codeunit "33019917";
                    begin
                        IF "Requested By" <> USERID THEN BEGIN

                              Approved := FALSE;
                              Rejected := TRUE;
                              VALIDATE("Rejected Date",TODAY);
                              "Rejected By" := USERID;
                              MODIFY;
                              DocNotificationMgt.SendTrainingDisapprovedMailtoEmployee(Rec); //SRT Feb 7th 2019
                          END ELSE BEGIN
                            MESSAGE('Disapprover must be different');
                          END ;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance //SRT Feb 7th 2019
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance //SRT Feb 7th 2019
    end;

    trigger OnOpenPage()
    begin
        IF "Sent for Approval" THEN
          approvalSent := TRUE;
        
        IF ("Sent for Approval") AND (Completed) THEN
          approvalSent := TRUE;
        
        IF Completed THEN BEGIN
          isComplete := FALSE;
          FieldEditable := FALSE;
          END
        ELSE BEGIN
          isComplete := TRUE;
          FieldEditable := TRUE;
          END;
        /*IF Canceled THEN
          approvalSent := FALSE;
          */

    end;

    var
        GblDocAppMngt: Codeunit "33019915";
        GblDocAppPostCheck: Codeunit "33019916";
        GblDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll;
        TrainingList: Record "33020358";
        TrainingRequestsLineRec: Record "33020360";
        FieldEditable: Boolean;
        approvalSent: Boolean;
        isComplete: Boolean;

    local procedure SetControlAppearance()
    begin
        FieldEditable := TRUE;
        IF (NOT Rejected) OR (NOT Approved) OR (NOT Completed) THEN
          FieldEditable := FALSE;
        FieldEditable := TRUE;
    end;
}

