page 33019836 "CSV Requisition Upload"
{
    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table33019835;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Order Quantity"; "Order Quantity")
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
                Caption = '&Import Requisition';
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
                        XMLPORT.IMPORT(50003, CurrStream);
                        IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                    END;
                end;
            }
            action("&Create Import Purchase Order")
            {
                Caption = '&Create Import Purchase Order';
                Image = CreatePutAway;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProcessUplodedReq.RUN;
                end;
            }
        }
    }

    var
        ProcessUplodedReq: Report "33019832";
}

