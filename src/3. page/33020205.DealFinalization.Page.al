page 33020205 "Deal Finalization"
{
    PageType = List;
    SourceTable = Table33020199;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Date)
                {
                }
                field("Quotation No."; "Quotation No.")
                {
                }
                field("Quotation Date"; "Quotation Date")
                {
                }
                field(Make; Make)
                {
                }
                field("Model No."; "Model No.")
                {
                }
                field("Model Name"; "Model Name")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Model Version Name"; "Model Version Name")
                {
                }
                field("Price (LCY)"; "Price (LCY)")
                {
                }
                field("Price Add. Currency"; "Price Add. Currency")
                {
                }
                field(Color; Color)
                {
                }
                field("Deal Type"; "Deal Type")
                {
                }
                field("Vehicle Details"; "Vehicle Details")
                {
                    Editable = FieldEditable;
                }
                field("Year of Make"; "Year of Make")
                {
                    Editable = FieldEditable;
                }
                field("Chasis No."; "Chasis No.")
                {
                    Editable = FieldEditable;
                }
                field("Value of Exchange (LCY)"; "Value of Exchange (LCY)")
                {
                    Editable = FieldEditable;
                }
                field("VE Add. Currency"; "VE Add. Currency")
                {
                }
                field("Discount Offered"; "Discount Offered")
                {
                }
                field("Signing Amount Provided (LCY)"; "Signing Amount Provided (LCY)")
                {
                }
                field("SAP Add. Currency"; "SAP Add. Currency")
                {
                }
                field("Promised Date of Delivery"; "Promised Date of Delivery")
                {
                }
                field("Terms of Payment"; "Terms of Payment")
                {
                }
                field("Facilities Provided"; "Facilities Provided")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102159032>")
            {
                Caption = 'Attachment';
                action(ImportDFinDoc)
                {
                    Caption = 'Import';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Text33020142: Label 'Picture imported successfully!';
                    begin
                        //Code open an browser and take the input file and saves in the database.
                        //gblFileName := gblRBAutoMngt.BLOBImport(gblBLOBRef,gblImportFromFile,gblImportFromFile = '');
                        gblFileName := gblRBAutoMngt.BLOBImport(gblBLOBRef, gblImportFromFile);
                        IF gblFileName <> '' THEN BEGIN
                            gblDFinAttachment.INIT;
                            gblDFinAttachment."Attachment Type" := gblDFinAttachment."Attachment Type"::DealFinal;
                            gblDFinAttachment."Prospect No." := "Prospect No.";
                            gblDFinAttachment.Attachment := gblBLOBRef.Blob;
                            gblDFinAttachment."File Name" := "Prospect No." + '_DealFinalization';
                            gblDFinAttachment."File Extension" := getFileExtension(gblFileName);
                            gblDFinAttachment.INSERT;
                            MESSAGE(Text33020142);
                        END;

                        RESET;
                    end;
                }
                action(OpenDFinDoc)
                {
                    Caption = 'Open';
                    Image = TeamSales;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Exports picture to temporary location of operating system and shows the picture.
                        gblDFinAttachment.RESET;
                        gblDFinAttachment.SETFILTER("Attachment Type", 'DealFinal');
                        gblDFinAttachment.SETRANGE("Prospect No.", "Prospect No.");
                        IF gblDFinAttachment.FIND('-') THEN BEGIN
                            gblDFinAttachment.CALCFIELDS(Attachment);
                            IF gblDFinAttachment.Attachment.HASVALUE THEN BEGIN
                                gblFileName := TEMPORARYPATH + gblDFinAttachment."File Name" + '.' + gblDFinAttachment."File Extension";
                                gblExportToFile := gblDFinAttachment.Attachment.EXPORT(gblFileName);
                                HYPERLINK(gblFileName);
                                //DeleteFile(gblFileName); //This does not work in RTC environment.
                            END;
                        END ELSE
                            MESSAGE(Text33020149);
                    end;
                }
                action(ExportDFinDoc)
                {
                    Caption = 'Export';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Here file is exported to the specified location by the user.
                        gblDFinAttachment.RESET;
                        gblDFinAttachment.SETFILTER("Attachment Type", 'DealFinal');
                        gblDFinAttachment.SETRANGE("Prospect No.", "Prospect No.");
                        IF gblDFinAttachment.FIND('-') THEN BEGIN
                            gblDFinAttachment.CALCFIELDS(Attachment);
                            IF gblDFinAttachment.Attachment.HASVALUE THEN BEGIN
                                gblBLOBRef.Blob := gblDFinAttachment.Attachment;
                                IF gblExportToFile = '' THEN BEGIN
                                    gblFileFilter := gblDFinAttachment."File Extension" + ' ';
                                    gblFileFilter := gblFileFilter + '(*' + gblDFinAttachment."File Extension" + ')|*.' + gblDFinAttachment."File Extension";
                                    gblFileName := gblDFinAttachment."File Name" + '.' + gblDFinAttachment."File Extension";
                                    //gblFileName := gblCommonDialogMgt.OpenFile(Text33020143,gblFileName,4,gblFileFilter,1); commented because code cannot be found
                                    gblExportToFile := gblBLOBRef.Blob.EXPORT(gblFileName);
                                    MESSAGE(Text33020145);
                                END;
                            END;
                        END ELSE
                            MESSAGE(Text33020149);
                    end;
                }
                separator()
                {
                }
                action(DeleteDFinDoc)
                {
                    Caption = 'Delete';
                    Image = Delete;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Code to delete Picture record.
                        gblConfirmDelete := DIALOG.CONFIRM(Text33020146, FALSE);

                        IF gblConfirmDelete THEN BEGIN
                            gblDFinAttachment.RESET;
                            gblDFinAttachment.SETFILTER("Attachment Type", 'DealFinal');
                            gblDFinAttachment.SETRANGE("Prospect No.", "Prospect No.");
                            IF gblDFinAttachment.FIND('-') THEN BEGIN
                                gblDFinAttachment.DELETE;
                                MESSAGE(Text33020150);
                            END ELSE
                                MESSAGE(Text33020149);
                        END ELSE
                            MESSAGE(Text33020147, USERID);

                        RESET;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Making some fields non-editable.
        editableFields;
    end;

    var
        [InDataSet]
        FieldEditable: Boolean;
        gblRBAutoMngt: Codeunit "419";
        gblFileName: Text[250];
        gblBLOBRef: Record "99008535";
        gblImportFromFile: Text[250];
        gblDFinAttachment: Record "33020196";
        gblName: Text[100];
        gblExportToFile: Text[250];
        gblExportedFile: File;
        gblConfirmDelete: Boolean;
        gblCommonDialogMgt: Codeunit "412";
        gblFileFilter: Text[250];
        gblTempPath: Text[250];
        Text33020142: Label '\Doc';
        Text33020143: Label 'Export document?';
        Text33020144: Label 'All Files (*.*)|*.*';
        Text33020145: Label 'Document saved!';
        Text33020146: Label 'Are you sure - Delete?';
        Text33020147: Label 'Deletion aborted by user - %1!';
        Text33020148: Label 'When you have finished working with a document, you should delete the associated temporary file. Please note that this will not delete the document.\\Do you want to delete the temporary file?';
        Text33020149: Label 'There are no attachment for this prospect. Please upload one and try again.';
        Text33020150: Label 'Deleted!';

    [Scope('Internal')]
    procedure editableFields()
    begin
        IF ("Deal Type" = "Deal Type"::Exchange) THEN
            FieldEditable := TRUE
        ELSE
            FieldEditable := FALSE;
    end;

    [Scope('Internal')]
    procedure DeleteFile(PrmFileName: Text[250]): Boolean
    var
        i: Integer;
    begin
        //Deletes file after certain time interval.
        IF PrmFileName = '' THEN
            EXIT(FALSE);

        IF NOT EXISTS(PrmFileName) THEN
            EXIT(TRUE);

        REPEAT
            SLEEP(500);
            i := i + 1;
        UNTIL ERASE(PrmFileName) OR (i = 25);
        EXIT(NOT EXISTS(PrmFileName));
    end;

    [Scope('Internal')]
    procedure getFileExtension(PrmFileName: Text[250]): Text[20]
    var
        i: Integer;
    begin
        //Retrieves imported file extension.
        i := STRLEN(PrmFileName);
        WHILE COPYSTR(PrmFileName, i, 1) <> '.' DO
            i := i - 1;
        EXIT(COPYSTR(PrmFileName, i + 1, STRLEN(PrmFileName) - i));
    end;
}

