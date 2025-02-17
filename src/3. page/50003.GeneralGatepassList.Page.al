page 50003 "General Gatepass List"
{
    CardPageID = "General Gatepass";
    PageType = List;
    SourceTable = "Gatepass Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No"; Rec."Document No")
                {
                }
                field(Location; Rec.Location)
                {
                }
                field("Issued Date"; Rec."Issued Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Issued By"; Rec."Issued By")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field(Printed; Rec.Printed)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159021>")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+P';

                trigger OnAction()
                var
                    GatePass: Record "Gatepass Header";
                    SalesInvHdr: Record "Sales Invoice Header";
                begin
                    SalesInvHdr.RESET;
                    SalesInvHdr.SETRANGE("No.", Rec."External Document No.");
                    IF SalesInvHdr.FINDFIRST THEN
                        REPORT.RUNMODAL(3010750, TRUE, FALSE, SalesInvHdr)
                    ELSE BEGIN
                        CurrPage.SETSELECTIONFILTER(GatePass);
                        REPORT.RUNMODAL(50027, TRUE, FALSE, GatePass);
                    END;
                end;
            }
            action("Transfer Data")
            {
                Visible = false;

                trigger OnAction()
                var
                    GatepassHdr: Record "Gatepass Header";
                    GatepassHdr1: Record "Gatepass Header";
                begin
                    GatepassHdr.RESET;
                    IF GatepassHdr.FINDSET THEN
                        REPEAT
                            GatepassHdr1.RESET;
                            GatepassHdr1.SETRANGE("Document Type", GatepassHdr."Document Type");
                            GatepassHdr1.SETRANGE("Document No", GatepassHdr."Document No");
                            IF GatepassHdr1.FINDFIRST THEN BEGIN
                                GatepassHdr1."Old Document Type" := GatepassHdr."Document Type";
                                GatepassHdr1."Old Ext Document Type" := GatepassHdr."External Document Type";
                                GatepassHdr1.MODIFY;
                            END
                        UNTIL GatepassHdr.NEXT = 0;
                    MESSAGE('Completed');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterOnRecord;
    end;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "User Setup Management";
        UserProfileSetup: Record "User Profile Setup";
        UserSetup: Record "User Setup";
    begin
        Rec.FILTERGROUP(2);
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Service Resp. Ctr. Filter EDMS" <> '' THEN
                Rec.SETRANGE("Responsibility Center", UserSetup."Service Resp. Ctr. Filter EDMS");
        END;
        Rec.FILTERGROUP(0);
    end;
}

