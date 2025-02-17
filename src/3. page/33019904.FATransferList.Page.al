page 33019904 "FA Transfer List"
{
    Caption = 'FA Transfer History';
    CardPageID = "FA Transfer History Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019891;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FA No."; "FA No.")
                {
                    Caption = 'FA Code';
                }
                field(Date; Date)
                {
                }
                field("From Location Code"; "From Location Code")
                {
                }
                field(Description; Description)
                {
                    Caption = 'From Location Description';
                }
                field("To Location Code"; "To Location Code")
                {
                    Caption = 'To Location Code';
                }
                field("To Description"; "To Description")
                {
                    Caption = 'To Location Description';
                }
                field("From Responsible Emp"; "From Responsible Emp")
                {
                    Caption = 'From Employee Code';
                }
                field("From Emp Description"; "From Emp Description")
                {
                    Caption = 'Resposible Employee';
                }
                field("To Responsible Emp"; "To Responsible Emp")
                {
                    Caption = 'To Employee Code';
                }
                field("To Emp Description"; "To Emp Description")
                {
                    Caption = 'Responsible Employee';
                }
                field("User ID"; "User ID")
                {
                    Caption = 'User';
                }
            }
        }
        area(factboxes)
        {
            part("FA Transfer Register"; 33019906)
            {
                Caption = 'FA Transfer Register';
                SubPageLink = FA No.=FIELD(FA No.),
                              No.=FIELD(No.);
            }
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("<Action1102159024>")
            {
                Caption = 'Printing';
                action("<Action1102159025>")
                {
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        // to print
                         FATransfer.RESET;
                         FATransfer.SETRANGE(FATransfer."FA No.","FA No.");
                         FATransfer.SETRANGE(FATransfer."From Location Code","From Location Code");
                         REPORT.RUN(33019885,FALSE,TRUE,FATransfer);
                    end;
                }
                action(GatePass)
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CreateGatePass;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //CALCFIELDS(Description);
    end;

    var
        FATransfer: Record "33019891";
        STPLMgt: Codeunit "50000";

    [Scope('Internal')]
    procedure CreateGatePass()
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
                          Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
    begin
        CALCFIELDS("To Description","To Emp Description");
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.","FA No.");
        GatepassHeader.SETRANGE("External Document Type",GatepassHeader."External Document Type"::"FA Transfer");
        IF NOT GatepassHeader.FINDFIRST THEN
        BEGIN
          GatepassHeader.INIT;
          GatepassHeader."Document Type" := GatepassHeader."Document Type"::Admin;
          GatepassHeader."External Document Type" := GatepassHeader."External Document Type"::"FA Transfer";
          GatepassHeader."External Document No." := "FA No.";
          GatepassHeader."Ship Address":= "To Description";
          GatepassHeader.Owner := "To Emp Description";
          GatepassHeader.VALIDATE("Issued Date", TODAY);
          GatepassHeader.INSERT(TRUE);
        END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;
}

