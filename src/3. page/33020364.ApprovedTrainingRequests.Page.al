page 33020364 "Approved Training Requests"
{
    CardPageID = "Training Request Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020359;
    SourceTableView = WHERE(Approved = CONST(Yes),
                            Completed = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tr. Req. No."; "Tr. Req. No.")
                {
                }
                field(Department; Department)
                {
                }
                field("Training Code"; "Training Code")
                {
                }
                field("Training Topic"; "Training Topic")
                {
                }
                field("Training Objective"; "Training Objective")
                {
                }
                field("Duration (days)"; "Duration (days)")
                {
                }
                field(ODT; ODT)
                {
                }
                field("Requested By"; "Requested By")
                {
                }
                field("Requested Date"; "Requested Date")
                {
                }
                field(Approved; Approved)
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function(s)")
            {
                Caption = 'Function(s)';
                action("Fill Status")
                {
                    Caption = 'Fill Status';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Train: Record "33020359";
                    begin
                        Train.RESET;
                        Train.SETRANGE("Tr. Req. No.", "Tr. Req. No.");
                        PAGE.RUN(PAGE::Page33019857, Train);

                        /* ConfirmComplete := DIALOG.CONFIRM(Text001,TRUE);
                         IF ConfirmComplete THEN BEGIN

                          Completed := TRUE ;
                          VALIDATE("Completed Date",TODAY);
                          MODIFY;

                             TrainingReqLine.SETRANGE("Tr. Req. No.","Tr. Req. No.");
                             TrainingReqLine.FIND('-');
                                 REPEAT

                                   TrainingRec.INIT;
                                   TrainingRec."Employee Code" := TrainingReqLine."Part. Employee";
                                   TrainingRec.VALIDATE("Request No.","Tr. Req. No.");
                                   TrainingRec.VALIDATE("Training Code","Training Code");
                                   TrainingRec."Training Topic" := "Training Topic";
                                   TrainingRec."From Date" := TrainingReqHead."From Date";
                                   TrainingRec."To Date" := TrainingReqHead."To Date";
                                   TrainingRec.Completed := TRUE;
                                   TrainingRec.INSERT;

                                 UNTIL TrainingReqLine.NEXT = 0;

                       END;
                       */

                    end;
                }
            }
        }
    }

    var
        AppTrainings: Record "33020359";
        ConfirmComplete: Boolean;
        Text001: Label 'Do you want to Complete?';
        TrainingReqLine: Record "33020360";
        TrainingRec: Record "33020369";
        TrainingReqHead: Record "33020359";
}

