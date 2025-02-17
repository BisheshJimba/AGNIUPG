page 50040 "Purchase Order Buffer"
{
    PageType = List;
    SourceTable = Table33020255;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Purchase Order No."; "Purchase Order No.")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                }
                field("Document Profile"; "Document Profile")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("VIN - COGS"; "VIN - COGS")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code")
                {
                }
                field("Document Class"; "Document Class")
                {
                }
                field("Document Subclass"; "Document Subclass")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                    Caption = 'Direct Unit Cost';
                }
                field("Line Type"; "Line Type")
                {
                }
                field("Imported By"; "Imported By")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1102159013>")
            {
                Caption = '&Import Purchase';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CurrFile: File;
                    CurrStream: InStream;
                    ClientFileName: Text[1024];
                    SelectCSVFile: Label 'Select the CSV Requisition File.';
                begin
                    BEGIN
                        IF ISSERVICETIER THEN BEGIN
                            IF NOT UPLOADINTOSTREAM(
                                              SelectCSVFile,
                                               'C:\',
                                               'XML File *.csv| *.csv',
                                                ClientFileName,
                                                CurrStream) THEN
                                EXIT;
                        END
                        ELSE BEGIN
                            CurrFile.OPEN('C:\');
                            CurrFile.CREATEINSTREAM(CurrStream);
                        END;
                        XMLPORT.IMPORT(50014, CurrStream);
                        IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                    END;
                end;
            }
            action("<Action1000000020>")
            {
                Caption = '&Create Purchase';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Text000: Label 'Do you want to create Purchase Documents for applied filters?';
                begin
                    IF CONFIRM(Text000, TRUE) THEN BEGIN
                        ProcessBuffer(Rec);
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            //UserSetup.GET(USERID);
            //SETRANGE("Location Code",UserSetup."Default Location");
            FILTERGROUP(0);
        END;
    end;

    var
        UserMgt: Codeunit "5700";
        UserSetup: Record "91";
}

