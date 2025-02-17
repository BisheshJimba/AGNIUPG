page 50019 "QR Scan Worksheet"
{
    PageType = Document;
    SourceTable = Table33019974;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                repeater(Scan)
                {
                    field("QR Text"; "QR Text")
                    {

                        trigger OnValidate()
                        begin
                            CLEAR(QRScanforVerification);
                            QRScanforVerification.InsertData("QR Text");
                            DELETEALL;
                        end;
                    }
                }
                part(; 50013)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("1. Reset QR Status on Item Ledger")
            {
                Enabled = false;
                Image = ResetStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    QRScanforVerification.ResetVerificationInILE;
                end;
            }
            action("2. Verify Items")
            {
                Image = Track;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    QRScanforVerification.VerifyItems;
                end;
            }
            action("3. Delete All")
            {
                Enabled = false;
                Image = DeleteExpiredComponents;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    QRScanforVerification.DeleteData;
                end;
            }
        }
        area(navigation)
        {
            action(OpenLostItems)
            {
                Caption = 'Lost Item Ledger Entries';
                Enabled = true;
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    QRScanforVerification.OpenLostItems;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*IF NOT GET THEN BEGIN
          INIT;
          INSERT;
        END;
        */

    end;

    var
        QRText: Text[250];
        QRScanforVerification: Record "33019975";
}

