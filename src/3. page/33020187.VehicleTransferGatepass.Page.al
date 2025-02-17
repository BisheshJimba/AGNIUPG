page 33020187 "Vehicle Transfer - Gatepass"
{
    Caption = 'Vehicle Transfer - Gatepass';
    PageType = Document;
    SourceTable = Table50004;
    SourceTableView = WHERE(Document Type=CONST(Admin));

    layout
    {
        area(content)
        {
            group("Vehicle Transfer - Gatepass")
            {
                Caption = 'Header';
                field("Document No"; "Document No")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
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
                field(Person; Person)
                {
                    Caption = 'Person/Driver';
                }
                field(Destination; Destination)
                {
                }
                field(Owner; Owner)
                {
                }
            }
            part(Lines; 33020188)
            {
                Caption = 'Lines';
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No);
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(PrintDoc)
            {
                Caption = '&Print';
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LclGtpsHdr: Record "50004";
                begin
                    LclGtpsHdr.RESET;
                    LclGtpsHdr.SETRANGE("Document Type","Document Type");
                    LclGtpsHdr.SETRANGE("Document No","Document No");
                    REPORT.RUN(33020168,TRUE,FALSE,LclGtpsHdr);
                end;
            }
        }
    }
}

