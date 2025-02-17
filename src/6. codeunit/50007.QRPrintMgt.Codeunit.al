codeunit 50007 "QR Print Mgt."
{
    Permissions = TableData 32 = rm;
    TableNo = 32;

    trigger OnRun()
    var
        ItemLedgEntry: Record "32";
        TempBlob: Record "99008535";
        QRCodeInput: Text[1024];
        QRCodeFileName: Text[1024];
        QRPrintDetails: Record "33019982";
    begin
        // Save a QR code image into a file in a temporary folder

        ItemLedgEntry := Rec;

        // Assign QR Code Information for scanning
        QRCodeInput := CreateQRCodeInput(ItemLedgEntry."QR Code Text");
        QRCodeFileName := GetQRCode(QRCodeInput);
        QRCodeFileName := MoveToMagicPath(QRCodeFileName); // To avoid confirmation dialogue on RTC

        // Load the image from file into the BLOB field
        CLEAR(TempBlob);
        ThreeTierMgt.BLOBImport(TempBlob, QRCodeFileName);
        IF TempBlob.Blob.HASVALUE THEN BEGIN
            QRPrintDetails.RESET;
            QRPrintDetails.SETRANGE("Entry No.", ItemLedgEntry."Entry No.");
            IF QRPrintDetails.FINDFIRST THEN BEGIN
                QRPrintDetails."QR Code Blob" := TempBlob.Blob;
                QRPrintDetails.MODIFY;
            END ELSE BEGIN
                QRPrintDetails.INIT;
                QRPrintDetails."Entry No." := ItemLedgEntry."Entry No.";
                QRPrintDetails."QR Code Text" := ItemLedgEntry."QR Code Text";
                QRPrintDetails."QR Code Blob" := TempBlob.Blob;
                QRPrintDetails.INSERT;
            END;
            //ItemLedgEntry."QR Code Blob" := TempBlob.Blob; SM commented to reduce item ledger entry table lock issue
            //ItemLedgEntry.MODIFY;
        END;

        // Erase the temporary file
        IF NOT ISSERVICETIER THEN
            IF EXISTS(QRCodeFileName) THEN
                ERASE(QRCodeFileName);
    end;

    var
        ThreeTierMgt: Codeunit "419";

    local procedure CreateQRCodeInput(QRCodeText: Text[250]) QRCodeInput: Text[1024]
    begin
        EXIT(QRCodeText);
    end;

    local procedure GetQRCode(QRCodeInput: Text[1024]) QRCodeFileName: Text[1024]
    var
        [RunOnClient]
        IBarCodeProvider: DotNet IBarcodeProvider;
    begin
        GetBarCodeProvider(IBarCodeProvider);
        QRCodeFileName := IBarCodeProvider.GetBarcode(QRCodeInput);
    end;

    [Scope('Internal')]
    procedure GetBarCodeProvider(var IBarCodeProvider: DotNet IBarcodeProvider)
    var
        [RunOnClient]
        QRCodeProvider: DotNet QRCodeProvider;
    begin
        QRCodeProvider := QRCodeProvider.QRCodeProvider;
        IBarCodeProvider := QRCodeProvider;
    end;

    [Scope('Internal')]
    procedure MoveToMagicPath(SourceFileName: Text[1024]) DestinationFileName: Text[1024]
    var
        FileSystemObject: Automation;
    begin
        DestinationFileName := ThreeTierMgt.ClientTempFileName('');
        IF ISCLEAR(FileSystemObject) THEN
            CREATE(FileSystemObject, TRUE, TRUE);
        FileSystemObject.MoveFile(SourceFileName, DestinationFileName);
    end;
}

