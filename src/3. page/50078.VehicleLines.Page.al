page 50078 "Vehicle Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table130416;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Serial No."; "Serial No.")
                {
                }
                field("Chasis No."; "Chasis No.")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Dealer Type"; "Dealer Type")
                {
                }
                field("LC/PO Details"; "LC/PO Details")
                {
                }
                field("Customer Details"; "Customer Details")
                {
                }
                field("Current MRP"; "Current MRP")
                {
                }
                field("Old MRP"; "Old MRP")
                {
                }
                field("Difference in MRP"; "Difference in MRP")
                {
                }
                field("Discount On Old Price"; "Discount On Old Price")
                {
                }
                field("Discount On New Price"; "Discount On New Price")
                {
                }
                field("Billing Price"; "Billing Price")
                {
                }
                field("Model Year"; "Model Year")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("F&unctions")
                {
                    Caption = 'F&unctions';
                    Image = "Action";
                    action(Upload)
                    {

                        trigger OnAction()
                        begin
                            ImportFile;
                        end;
                    }
                    action(Open)
                    {
                        Caption = 'Open';

                        trigger OnAction()
                        var
                            DefaultFileName: Text;
                        begin
                            CLEAR(TempBlob);
                            CALCFIELDS("Incoming File");
                            IF NOT "Incoming File".HASVALUE THEN
                                ERROR('file does not exist');
                            IF NOT TempBlob.Blob.HASVALUE THEN
                                TempBlob.Blob := "Incoming File";
                            DefaultFileName := "Memo No." + '.' + Extension;
                            FileManagement.BLOBExport(TempBlob, DefaultFileName, TRUE);
                            MESSAGE('Downloaded');
                        end;
                    }
                    action(DeleteFiles)
                    {
                        Caption = 'Delete';

                        trigger OnAction()
                        begin
                            DELETE;
                        end;
                    }
                }
            }
        }
    }

    var
        FileManagement: Codeunit "419";
        FileName: Text;
        ClientFileName: Text;
        TempBlob: Record "99008535";
        DefaultFileName: Text;

    local procedure ImportFile()
    var
        ImportTxt: Label 'Insert File';
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
    begin
        ClientFileName := '';
        CALCFIELDS("Incoming File");
        IF "Incoming File".HASVALUE THEN
            ERROR('File already uploaded.Please delete.');
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
        "Incoming File" := TempBlob.Blob;
        IF STRPOS(FileName, '.') <> 0 THEN
            Extension := COPYSTR(FileName, STRPOS(FileName, '.') + 1, STRLEN(FileName));
        Rec.MODIFY(TRUE);
        MESSAGE('Success');
    end;
}

