package util

import (
	"encoding/base64"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

// File signature struct
type fileSignature struct {
	Magic  []byte
	Offset int    // position in the file where magic occurs
	Ext    string // extension
}

// Known signatures (images, docs, audio, video, archives)
var signatures = []fileSignature{
	// Images
	{[]byte{0xFF, 0xD8, 0xFF}, 0, "jpg"},
	{[]byte{0x89, 0x50, 0x4E, 0x47}, 0, "png"},
	{[]byte("GIF87a"), 0, "gif"},
	{[]byte("GIF89a"), 0, "gif"},
	{[]byte("BM"), 0, "bmp"},
	{[]byte("RIFF"), 0, "webp"}, // needs extra check, simplified
	// Documents
	{[]byte("%PDF"), 0, "pdf"},
	{[]byte("PK"), 0, "zip"}, // docx, xlsx, pptx also
	{[]byte("Rar!"), 0, "rar"},
	// Audio
	{[]byte("ID3"), 0, "mp3"},
	{[]byte{0xFF, 0xFB}, 0, "mp3"},
	{[]byte("fLaC"), 0, "flac"},
	{[]byte("OggS"), 0, "ogg"},
	{[]byte("RIFF"), 0, "wav"}, // RIFF + WAVE
	// Video
	{[]byte("RIFF"), 0, "avi"}, // RIFF + AVI
	{[]byte{0x00, 0x00, 0x00, 0x18}, 0, "mp4"},
	{[]byte("ftyp"), 4, "mp4"},
	{[]byte{0x1A, 0x45, 0xDF, 0xA3}, 0, "mkv"},
}

func detectFileExtension(data []byte) string {
	for _, sig := range signatures {
		if len(data) < sig.Offset+len(sig.Magic) {
			continue
		}
		if string(data[sig.Offset:sig.Offset+len(sig.Magic)]) == string(sig.Magic) {
			return sig.Ext
		}
	}
	return "bin"
}

func SaveBase64ToFile(base64Str, destPath string) (*string, error) {

	if strings.HasPrefix(base64Str, "data:") {
		parts := strings.SplitN(base64Str, ",", 2)
		if len(parts) != 2 {
			return nil, errors.New("invalid base64 data URI")
		}
		base64Str = parts[1]
	}

	data, err := base64.StdEncoding.DecodeString(base64Str)
	if err != nil {
		return nil, fmt.Errorf("failed to decode base64: %w", err)
	}

	ext := detectFileExtension(data)

	if filepath.Ext(destPath) == "" {
		destPath = destPath + "." + ext
	}

	if err := os.WriteFile(destPath, data, 0644); err != nil {
		return nil, fmt.Errorf("failed to save file: %w", err)
	}

	return &destPath, nil
}
