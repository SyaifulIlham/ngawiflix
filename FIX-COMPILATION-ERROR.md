# Fix Compilation Error - BookingServlet

## Error yang Terjadi
```
java.lang.Error: Unresolved compilation problem: 
Type mismatch: cannot convert from Object to List<Integer>
at com.cinemax.servlet.BookingServlet.doPost(BookingServlet.java:62)
```

## Penyebab
Parsing `seatIds` dari JSON menggunakan `gson.fromJson(jsonObject.get("seatIds"), List.class)` mengembalikan `Object`, bukan `List<Integer>`.

## Solusi yang Diterapkan

### Sebelum (ERROR):
```java
List<Integer> seatIds = gson.fromJson(jsonObject.get("seatIds"), List.class)
        .stream()
        .map(obj -> ((Double) obj).intValue())
        .collect(Collectors.toList());
```

### Sesudah (FIXED):
```java
// Parse seat IDs from JsonArray
List<Integer> seatIds = new ArrayList<>();
JsonArray seatArray = jsonObject.getAsJsonArray("seatIds");
for (JsonElement element : seatArray) {
    seatIds.add(element.getAsInt());
}
```

## Imports yang Ditambahkan
```java
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import java.util.ArrayList;
```

## Status
✅ **FIXED** - No compilation errors

## Testing
1. Restart Tomcat server
2. Test booking flow:
   - Login → Pilih film → Pilih jadwal → Pilih kursi → Konfirmasi
3. Payment modal akan muncul
4. Booking akan tersimpan ke database

## Verification
Run di terminal:
```bash
# Clean and rebuild
mvn clean compile

# Check for compilation errors
mvn compile
```

Server log akan menampilkan:
```
=== Booking Request Started ===
Request body: {"scheduleId":1,"customerName":"...","seatIds":[1,2,3]}
Schedule ID: 1
Customer: ...
Seat IDs: [1, 2, 3]
...
Booking created successfully. Code: CX-XXXXXXXX
```
