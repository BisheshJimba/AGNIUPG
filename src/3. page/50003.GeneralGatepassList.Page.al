page 50003 "General Gatepass List"
{
    CardPageID = "General Gatepass";
    PageType = List;
    SourceTable = Table50004;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Document No"; "Document No")
                {
                }
                field(Location; Location)
                {
                }
                field("Issued Date"; "Issued Date")
                {
                }
                field(Description; Description)
                {
                }
                field("Issued By"; "Issued By")
                {
                }
                field(Type; Type)
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field(Printed; Printed)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
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
                    GatePass: Record "50004";
                    SalesInvHdr: Record "112";
                begin
                    SalesInvHdr.RESET;
                    SalesInvHdr.SETRANGE("No.", "External Document No.");
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
                    GatepassHdr: Record "50004";
                    GatepassHdr1: Record "50004";
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
        UserMgt: Codeunit "5700";
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
    begin
        FILTERGROUP(2);
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Service Resp. Ctr. Filter EDMS" <> '' THEN
                SETRANGE("Responsibility Center", UserSetup."Service Resp. Ctr. Filter EDMS");
        END;
        FILTERGROUP(0);
    end;
}

