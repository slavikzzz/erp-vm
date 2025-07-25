///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2025, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиОпераций

Функция ВыполнитьВыгрузку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена, ОбластьДанных = 0) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	УстановитьПривилегированныйРежим(Истина);
	
	СообщениеОбмена = "";
	
	ОбменДаннымиСервер.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыЧерезСтроку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, СообщениеОбмена);
	
	ХранилищеСообщенияОбмена = Новый ХранилищеЗначения(СообщениеОбмена, Новый СжатиеДанных(9));
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат "";
	
КонецФункции

Функция ВыполнитьВыгрузкуДанных(ИмяПланаОбмена,
								КодУзлаИнформационнойБазы,
								ИдентификаторФайлаСтрокой,
								ДлительнаяОперация,
								ИдентификаторОперации,
								ДлительнаяОперацияРазрешена,
								ОбластьДанных = 0) Экспорт
								
	ВойтиВОбластьДанных(ОбластьДанных);
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ИдентификаторФайла = Новый УникальныйИдентификатор;
	ИдентификаторФайлаСтрокой = Строка(ИдентификаторФайла);
	
	ВыполнитьВыгрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайла, ДлительнаяОперация, ИдентификаторОперации, ДлительнаяОперацияРазрешена);
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат "";
	
КонецФункции

Функция ВыполнитьВыгрузкуДанныхВнутренняяПубликация(ИмяПланаОбмена, КодУзлаИнформационнойБазы, 
	ИдентификаторЗадачи, ОбластьДанных) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
		
	ВыполнитьВыгрузкуДанныхВКлиентСерверномРежимеВнутренняяПубликация(
		ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторЗадачи, ОбластьДанных);
		
	Возврат "";
	
КонецФункции

Функция ВыполнитьЗагрузку(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена, ОбластьДанных = 0) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыЧерезСтроку(
		ИмяПланаОбмена, КодУзлаИнформационнойБазы, ХранилищеСообщенияОбмена.Получить());
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат "";
	
КонецФункции

Функция ВыполнитьЗагрузкуДанных(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайлаСтрокой, ДлительнаяОперация,
	ИдентификаторОперации, ДлительнаяОперацияРазрешена, ОбластьДанных = 0) Экспорт
								
	ВойтиВОбластьДанных(ОбластьДанных);
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ИдентификаторФайла = Новый УникальныйИдентификатор(ИдентификаторФайлаСтрокой);
	
	ВыполнитьЗагрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторФайла, ДлительнаяОперация, ИдентификаторОперации, ДлительнаяОперацияРазрешена);	
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат "";
	
КонецФункции

Функция ВыполнитьЗагрузкуДанныхВнутренняяПубликация(ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторЗадачи,
	ИдентификаторФайлаСтрокой, ОбластьДанных = 0) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ИдентификаторФайла = Новый УникальныйИдентификатор(ИдентификаторФайлаСтрокой);
	
	ВыполнитьЗагрузкуДанныхВКлиентСерверномРежимеВнутренняяПубликация(
		ИмяПланаОбмена, КодУзлаИнформационнойБазы, ИдентификаторЗадачи, ИдентификаторФайла, ОбластьДанных);

	Возврат "";
	
КонецФункции

Функция ПолучитьПараметрыИнформационнойБазы(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке,
	ОбластьДанных = 0, ДополнительныеПараметрыXDTO = Неопределено) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	Если ДополнительныеПараметрыXDTO <> Неопределено Тогда
		
		ДополнительныеПараметры = СериализаторXDTO.ПрочитатьXDTO(ДополнительныеПараметрыXDTO);
		
	КонецЕсли;
	
	Результат = ОбменДаннымиСервер.ПараметрыИнформационнойБазы(ИмяПланаОбмена, КодУзла, СообщениеОбОшибке, ДополнительныеПараметры);
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат СериализаторXDTO.ЗаписатьXDTO(Результат);
	
КонецФункции

Функция СоздатьУзелОбменаДанными(ПараметрыXDTO, ОбластьДанных = 0) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными(Истина);
	
	Параметры = СериализаторXDTO.ПрочитатьXDTO(ПараметрыXDTO);
	
	НастройкиПодключения = Параметры.НастройкиПодключения;
	
	МодульПомощникНастройки = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	
	Попытка
		
		Если НастройкиПодключения.Свойство("WSКонечнаяТочкаКорреспондента")
			И ЗначениеЗаполнено(НастройкиПодключения.WSКонечнаяТочкаКорреспондента) Тогда
			
			НастройкиПодключенияИзXML = 
				ТранспортСообщенийОбмена.НастройкиПодключенияИзXML(Параметры.СтрокаПараметровXML, "SM");
			
			// АПК:1416-выкл 4.2. Исключением можно считать структуры, формат которых не фиксирован (из корреспондента)
			
			// Подключение через внутреннюю публикацию из предыдущих версий не передаем идентификатор
			Если НЕ НастройкиПодключения.Свойство("ИдентификаторТранспорта") Тогда
				
				НастройкиПодключения.Вставить("ИдентификаторТранспорта", "SM");
				
			КонецЕсли;
			
			// При подключение через внутреннюю публикацию для новых видов транспорта
			Если НЕ НастройкиПодключения.Свойство("НастройкиТранспорта")
				ИЛИ ТипЗнч(НастройкиПодключения.НастройкиТранспорта) <> Тип("Структура") Тогда
				
				// Для работы в сервисе п/с ТехнологияСервиса.ОбменСообщениями обязательна,
				// поэтому проверка вызова не требуется.
				КонечнаяТочкаКорреспондента = ПланыОбмена["ОбменСообщениями"].НайтиПоКоду(НастройкиПодключения["WSКонечнаяТочкаКорреспондента"]); // @Non-NLS-2
				
				НастройкиТранспорта = Новый Структура;
				НастройкиТранспорта.Вставить("КонечнаяТочкаКорреспондента", КонечнаяТочкаКорреспондента);	
				НастройкиТранспорта.Вставить("ОбластьДанныхКорреспондента", НастройкиПодключения["WSОбластьДанныхКорреспондента"]); // @Non-NLS-2
				НастройкиТранспорта.Вставить("НаименованиеКорреспондента", "");
				НастройкиТранспорта.Вставить("ВнутренняяПубликация", Истина);
				
				НастройкиПодключения.Вставить("НастройкиТранспорта", НастройкиТранспорта);
				
			КонецЕсли;
			
			// АПК:1416-вкл
			
		Иначе
		
			НастройкиПодключенияИзXML = 
				ТранспортСообщенийОбмена.НастройкиПодключенияИзXML(Параметры.СтрокаПараметровXML, "WS");
				
			НастройкиПодключения.Вставить("ИдентификаторТранспорта", "ПассивныйРежим");
			НастройкиПодключения.Вставить("НастройкиТранспорта", Новый Структура);
		
		КонецЕсли;
	
		ТранспортСообщенийОбмена.ПроверитьИЗаполнитьНастройкиПодключенияXML(НастройкиПодключения, НастройкиПодключенияИзXML, Истина);
		
		МодульПомощникНастройки.ВыполнитьДействияПоНастройкеОбменаДанными(НастройкиПодключения);
		
	Исключение
		СообщениеОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииСозданиеОбменаДанными(),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
			
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат "";
	
КонецФункции

Функция УдалитьУзелОбменаДанными(ИмяПланаОбмена, ИдентификаторУзла, ОбластьДанных = 0) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = ОбменДаннымиСервер.УзелПланаОбменаПоКоду(ИмяПланаОбмена, ИдентификаторУзла);
		
	Если УзелОбмена = Неопределено Тогда
		ПредставлениеПрограммы = ?(ОбщегоНазначения.РазделениеВключено(),
			Метаданные.Синоним, ОбменДаннымиПовтИсп.ИмяЭтойИнформационнойБазы());
			
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В ""%1"" не найден узел плана обмена ""%2"" с идентификатором ""%3"".';
				|en = 'Exchange plan node ""%2"" with ID %3 is not found in %1.'"),
			ПредставлениеПрограммы, ИмяПланаОбмена, ИдентификаторУзла);
	КонецЕсли;
	
	ОбменДаннымиСервер.УдалитьНастройкуСинхронизации(УзелОбмена);
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат "";
	
КонецФункции

Функция ПолучитьСостояниеДлительнойОперации(ИдентификаторОперации, СтрокаСообщенияОбОшибке, ОбластьДанных = 0) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	УстановитьПривилегированныйРежим(Истина);
		
	СостоянияФоновогоЗадания = Новый Соответствие;
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Активно,           "Active");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Завершено,         "Completed");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.ЗавершеноАварийно, "Failed");
	СостоянияФоновогоЗадания.Вставить(СостояниеФоновогоЗадания.Отменено,          "Canceled");
		
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторОперации));
	
	Если ФоновоеЗадание = Неопределено Тогда
		
		СтрокаСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найдено длительной операции с идентификатором %1.';
				|en = 'No long-running operation with ID %1 was found.'"),
			ИдентификаторОперации);
			
		ВыйтиИзОбластиДанных(ОбластьДанных);
		
		Возврат СостоянияФоновогоЗадания.Получить(СостояниеФоновогоЗадания.Отменено);
		
	КонецЕсли;
	
	Если ФоновоеЗадание.ИнформацияОбОшибке <> Неопределено Тогда
		
		СтрокаСообщенияОбОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ФоновоеЗадание.ИнформацияОбОшибке);
		
	КонецЕсли;
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат СостоянияФоновогоЗадания.Получить(ФоновоеЗадание.Состояние);
	
КонецФункции

Функция ПодготовитьФайлДляПолучения(ИдентификаторФайла, РазмерБлока, ИдентификаторПередачи, КоличествоЧастей, Область = 0) Экспорт
	
	ВойтиВОбластьДанных(Область);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторПередачи = Новый УникальныйИдентификатор;
	
	ТранспортСообщенийОбменаПереопределяемый.ПередПолучениемФайлаИзХранилища(ИдентификаторФайла);
	
	ИмяИсходногоФайла = ОбменДаннымиСервер.ПолучитьФайлИзХранилища(ИдентификаторФайла);
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(ИдентификаторПередачи);
	
	ИмяИсходногоФайлаВоВременномКаталоге = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, "data.zip");
	
	СоздатьКаталог(ВременныйКаталог);
	
	ПереместитьФайл(ИмяИсходногоФайла, ИмяИсходногоФайлаВоВременномКаталоге);
	
	Если РазмерБлока <> 0 Тогда
		// Разделение файла на части
		ИменаФайлов = РазделитьФайл(ИмяИсходногоФайлаВоВременномКаталоге, РазмерБлока * 1024);
		КоличествоЧастей = ИменаФайлов.Количество();
		
		УдалитьФайлы(ИмяИсходногоФайлаВоВременномКаталоге);
	Иначе
		КоличествоЧастей = 1;
		ПереместитьФайл(ИмяИсходногоФайлаВоВременномКаталоге, ИмяИсходногоФайлаВоВременномКаталоге + ".1");
	КонецЕсли;
	
	ВыйтиИзОбластиДанных(Область);
		
	Возврат "";
	
КонецФункции

Функция ПолучитьЧастьФайла(ИдентификаторПередачи, НомерЧасти, ДанныеЧасти, Область = 0) Экспорт
	
	ВойтиВОбластьДанных(Область);
	
	ИменаФайлов = НайтиФайлЧасти(ВременныйКаталогВыгрузки(ИдентификаторПередачи), НомерЧасти);
	
	Если ИменаФайлов.Количество() = 0 Тогда
		
		ШаблонСообщения = НСтр("ru = 'Не найден фрагмент %1 сессии передачи с идентификатором %2';
								|en = 'Part %1 of the transfer session with ID %2 is not found'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, Строка(НомерЧасти), Строка(ИдентификаторПередачи));
		ВызватьИсключение(ТекстСообщения);
		
	ИначеЕсли ИменаФайлов.Количество() > 1 Тогда
		
		ШаблонСообщения = НСтр("ru = 'Найдено несколько фрагментов %1 сессии передачи с идентификатором %2';
								|en = 'Multiple parts %1 of the transfer session with ID %2 are not found'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, Строка(НомерЧасти), Строка(ИдентификаторПередачи));
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ИмяФайлаЧасти = ИменаФайлов[0].ПолноеИмя;
	ДанныеЧасти = Новый ДвоичныеДанные(ИмяФайлаЧасти);
	
	ВыйтиИзОбластиДанных(Область);
	
	Возврат "";
	
КонецФункции

Функция УдалитьСообщениеОбмена(ИдентификаторПередачи) Экспорт
	
	Попытка
		УдалитьФайлы(ВременныйКаталогВыгрузки(ИдентификаторПередачи));
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат "";
	
КонецФункции

Функция ПоместитьЧастьФайла(ИдентификаторПередачи, НомерЧасти, ДанныеЧасти, Область = 0) Экспорт
	
	ВойтиВОбластьДанных(Область);
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(ИдентификаторПередачи);
	
	Если НомерЧасти = 1 Тогда
		
		СоздатьКаталог(ВременныйКаталог);
		
	КонецЕсли;
	
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, ПолучитьИмяФайлаЧасти(НомерЧасти));
	
	ДанныеЧасти.Записать(ИмяФайла);
	
	ВыйтиИзОбластиДанных(Область);
	
	Возврат "";
	
КонецФункции

Функция СобратьФайлИзЧастей(ИдентификаторПередачи, КоличествоЧастей, ИдентификаторФайла, Область = 0) Экспорт
	
	ВойтиВОбластьДанных(Область);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВременныйКаталог = ВременныйКаталогВыгрузки(ИдентификаторПередачи);
	
	ФайлыЧастейДляОбъединения = Новый Массив;
	
	Для НомерЧасти = 1 По КоличествоЧастей Цикл
		
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, ПолучитьИмяФайлаЧасти(НомерЧасти));
		
		Если НайтиФайлы(ИмяФайла).Количество() = 0 Тогда
			ШаблонСообщения = НСтр("ru = 'Не найден фрагмент %1 сессии передачи с идентификатором %2.
					|Необходимо убедиться, что в настройках программы заданы параметры
					|""Каталог временных файлов для Linux"" и ""Каталог временных файлов для Windows"".';
					|en = 'Part %1 of the transfer session with ID %2 is not found. 
					|Make sure that the ""Directory of temporary files for Linux""
					| and ""Directory of temporary files for Windows"" parameters are specified in the application settings.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения, Строка(НомерЧасти), Строка(ИдентификаторПередачи));
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
		ФайлыЧастейДляОбъединения.Добавить(ИмяФайла);
		
	КонецЦикла;
	
	ИмяАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ВременныйКаталог, "data.zip");
	
	ОбъединитьФайлы(ФайлыЧастейДляОбъединения, ИмяАрхива);
	
	Разархиватор = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Если Разархиватор.Элементы.Количество() = 0 Тогда
		
		Попытка
			УдалитьФайлы(ВременныйКаталог);
		Исключение
			ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
				УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));	
		КонецПопытки;
		
		ВыйтиИзОбластиДанных(Область);
		ВызватьИсключение(НСтр("ru = 'Файл архива не содержит данных.';
								|en = 'The archive file is empty.'"));
		
	КонецЕсли;
	
	КаталогВыгрузки = ОбменДаннымиСервер.КаталогВременногоХранилищаФайлов();
	
	ЭлементАрхива = Разархиватор.Элементы.Получить(0);
	ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(КаталогВыгрузки, ЭлементАрхива.Имя);
	
	Разархиватор.Извлечь(ЭлементАрхива, КаталогВыгрузки);
	Разархиватор.Закрыть();
	
	ИдентификаторФайла = ОбменДаннымиСервер.ПоместитьФайлВХранилище(ИмяФайла, ИдентификаторФайла);
	
	ТранспортСообщенийОбменаПереопределяемый.ПриПомещенииФайлаВХранилище(ИмяФайла, ИдентификаторФайла);
	
	Попытка
		УдалитьФайлы(ВременныйКаталог);
	Исключение
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииУдалениеВременногоФайла(),
			УровеньЖурналаРегистрации.Ошибка,,, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	ВыйтиИзОбластиДанных(Область);
	
	Возврат "";
	
КонецФункции

Функция ПоместитьСообщениеДляСопоставленияДанных(ИмяПланаОбмена, ИдентификаторУзла, ИдентификаторФайла, ОбластьДанных = 0) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	
	УзелОбмена = ОбменДаннымиСервер.УзелПланаОбменаПоКоду(ИмяПланаОбмена, ИдентификаторУзла);
		
	Если УзелОбмена = Неопределено Тогда
		
		ПредставлениеПрограммы = ?(ОбщегоНазначения.РазделениеВключено(),
			Метаданные.Синоним, ОбменДаннымиПовтИсп.ИмяЭтойИнформационнойБазы());
			
		ВыйтиИзОбластиДанных(ОбластьДанных);	
			
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В ""%1"" не найден узел плана обмена ""%2"" с идентификатором ""%3"".';
				|en = 'Exchange plan node ""%2"" with ID %3 is not found in %1.'"),
			ПредставлениеПрограммы, ИмяПланаОбмена, ИдентификаторУзла);
			
	КонецЕсли;
	
	ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	
	ОбменДаннымиСервер.ПроверитьИспользованиеОбменаДанными();
	
	ОбменДаннымиСлужебный.ПоместитьСообщениеДляСопоставленияДанных(УзелОбмена, ИдентификаторФайла);
	
	// У веб-клиента и тонкого клиент разные временные каталоги. 
	// Если продолжить настройку синхронизации из тонкого клиента, то будет ошибка из-за отсутствия файла во временном
	// каталоге тонкого клиента. Что бы этого не было, перемещаем файл сопоставления в каталог, к которому гарантированно
	// будет доступ у двух сеансов.
	ПереместитьФайлСообщенияДляФайловойИБ(ИдентификаторФайла);
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат "";
	
КонецФункции

Функция ТестовоеПодключение(ИмяПланаОбмена, КодУзла, Результат, ОбластьДанных = 0) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Проверяем наличие прав для выполнения обмена.
	Попытка
		ОбменДаннымиСервер.ПроверитьВозможностьВыполненияОбменов(Истина);
	Исключение
		Результат = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	// Проверяем блокировку информационной базы для обновления.
	Попытка
		ПроверитьБлокировкуИнформационнойБазыДляОбновления();
	Исключение
		Результат = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	// Проверяем наличие узла плана обмена (возможно узел уже удален).
	УзелСсылка = ОбменДаннымиСервер.УзелПланаОбменаПоКоду(ИмяПланаОбмена, КодУзла); 
	Если УзелСсылка = Неопределено
		Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УзелСсылка, "ПометкаУдаления") Тогда
		ПредставлениеПрограммы = ?(ОбщегоНазначения.РазделениеВключено(),
			Метаданные.Синоним, ОбменДаннымиПовтИсп.ИмяЭтойИнформационнойБазы());
			
		ПредставлениеПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Представление();
			
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В ""%1"" не найдена настройка синхронизации данных ""%2"" с идентификатором ""%3"".';
				|en = 'Data synchronization setting ""%2"" with ID %3 is not found in %1.'"),
			ПредставлениеПрограммы, ПредставлениеПланаОбмена, КодУзла);
			
		ВыйтиИзОбластиДанных(ОбластьДанных);
			
		Возврат Ложь;
	КонецЕсли;
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
	Возврат Истина;
	
КонецФункции

Функция ИзменитьТранспортНаВебСервисВнутренняяПубликация(ПараметрыXDTO, ОбластьДанных) Экспорт
	
	ВойтиВОбластьДанных(ОбластьДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = СериализаторXDTO.ПрочитатьXDTO(ПараметрыXDTO);
	
	УзелОбмена = ОбменДаннымиСервер.УзелПланаОбменаПоКоду(Параметры.ИмяПланаОбмена, Параметры.КодУзлаКорреспондента);
		
	Если УзелОбмена = Неопределено Тогда
		
		ПредставлениеПрограммы = ?(ОбщегоНазначения.РазделениеВключено(),
			Метаданные.Синоним, ОбменДаннымиПовтИсп.ИмяЭтойИнформационнойБазы());
			
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В ""%1"" не найден узел плана обмена ""%2"" с идентификатором ""%3"".';
				|en = 'Exchange plan node ""%2"" with ID %3 is not found in %1.'"),
			ПредставлениеПрограммы, Параметры.ИмяПланаОбмена, Параметры.КодУзлаКорреспондента);
			
	КонецЕсли;
		
	КонечнаяТочка = ПланыОбмена["ОбменСообщениями"].НайтиПоКоду(Параметры.КонечнаяТочкаКорреспондента);	
	
	НастройкиТранспорта = Новый Структура; 
	НастройкиТранспорта.Вставить("ВнутренняяПубликация", Истина);
	НастройкиТранспорта.Вставить("КонечнаяТочка", "");
	НастройкиТранспорта.Вставить("КонечнаяТочкаКорреспондента", КонечнаяТочка);
	НастройкиТранспорта.Вставить("НаименованиеКорреспондента", "");
	НастройкиТранспорта.Вставить("ОбластьДанныхКорреспондента", Параметры.ОбластьДанныхКорреспондента);
	
	ТранспортСообщенийОбмена.СохранитьНастройкиТранспорта(УзелОбмена, "SM", НастройкиТранспорта, Истина);
	
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Изменение транспорта узла ""%1"" плана обмена ""%2"" в области данных %3 на ""Интернет"".';
			|en = 'Change the transport for node ""%1"" of exchange plan ""%2"" in data area %3 to ""Internet connection"".'"),
		Параметры.КодУзлаКорреспондента, Параметры.ИмяПланаОбмена, ОбластьДанных);
			
	ЗаписьЖурналаРегистрации(ОбменДаннымиВебСервис.СобытиеЖурналаРегистрацииИзменениеТранспортаНаWS(),
		УровеньЖурналаРегистрации.Информация, , , ТекстСообщения);
	
	СтруктураЗаписи = Новый Структура("Корреспондент", УзелОбмена);
	ОбменДаннымиСлужебный.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "НастройкиТранспортаОбменаОбластиДанных");
	
	ВыйтиИзОбластиДанных(ОбластьДанных);
	
КонецФункции

Функция ОтветныйВызов(ИдентификаторЗадачи, Ошибка, Область) Экспорт
	
	ВойтиВОбластьДанных(Область);
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульОбменДаннымиВнутренняяПубликация = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиВнутренняяПубликация");
	МодульОбменДаннымиВнутренняяПубликация.ОтметитьВыполнениеЗадачи(ИдентификаторЗадачи, Ошибка);
		
	Если Ошибка = "" Тогда
		
		Задача = МодульОбменДаннымиВнутренняяПубликация.СледующаяЗадача(ИдентификаторЗадачи);
		ЗадачаПред = ИдентификаторЗадачи;
		
		Если Задача = Неопределено Тогда
			Возврат "";
		КонецЕсли;
		
		ПараметрыПроцедуры = Новый Массив;
		ПараметрыПроцедуры.Добавить(Задача);
		ПараметрыПроцедуры.Добавить(ЗадачаПред);

		Ключ = Задача.ИдентификаторЗадачи;

		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("Ключ", Лев(Ключ, 120));
		ПараметрыЗадания.Вставить("ИмяМетода"    , "ОбменДаннымиВнутренняяПубликация.ВыполнитьОчередьЗадач");
		ПараметрыЗадания.Вставить("ОбластьДанных", Область);
		ПараметрыЗадания.Вставить("Использование", Истина);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяДатаСеанса());
		ПараметрыЗадания.Вставить("Параметры", ПараметрыПроцедуры);
		ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
		ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 900);

		МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
		МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	
	Иначе
		
		Задача = МодульОбменДаннымиВнутренняяПубликация.ЗадачаПоИдентификатору(ИдентификаторЗадачи);
		
		Отказ = Ложь;
		СтруктураНастроекОбмена = 
			МодульОбменДаннымиВнутренняяПубликация.НастройкиОбменаДляУзлаИнформационнойБазы(Задача.УзелИнформационнойБазы, Задача.Действие, Отказ);
		СтруктураНастроекОбмена.РезультатВыполненияОбмена = Перечисления.РезультатыВыполненияОбмена.Ошибка;
		
		ОбменДаннымиСервер.ЗаписьЖурналаРегистрацииОбменаДанными(Ошибка, СтруктураНастроекОбмена, Истина);
		ОбменДаннымиСервер.ЗафиксироватьЗавершениеОбмена(СтруктураНастроекОбмена);
		
	КонецЕсли;
	
	ВыйтиИзОбластиДанных(Область);
	
КонецФункции

Функция СтатусЗадачи(ИдентификаторЗадачи) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыЗадания = Новый Структура("Ключ", ИдентификаторЗадачи);
	
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	Задания = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
	
	Если Задания.Количество() > 0 Тогда
		
		Состояние = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Задания[0].Идентификатор, "СостояниеЗадания");
		Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(Состояние);
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;

	
КонецФункции

Функция ОстановитьЗадачи(ИдентификаторыЗадач, Область) Экспорт
	
	ВойтиВОбластьДанных(Область);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторыЗадачМассив = СериализаторXDTO.ПрочитатьXDTO(ИдентификаторыЗадач);
	
	Для Каждого ИдентификаторЗадачи Из ИдентификаторыЗадачМассив Цикл
		
		Отбор = Новый Структура("Ключ", ИдентификаторЗадачи);
		МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
		Задания = МодульОчередьЗаданий.ПолучитьЗадания(Отбор);
	
		Для Каждого Задание Из Задания Цикл
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 0);
			
			МодульОчередьЗаданий.ИзменитьЗадание(Задание.Идентификатор, ПараметрыЗадания);
			МодульОчередьЗаданий.УдалитьЗадание(Задание.Идентификатор);
			
			УникальныйИдентификаторФЗ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Задание.Идентификатор, "ИсполняющееФоновоеЗадание");
				
			ДлительныеОперации.ОтменитьВыполнениеЗадания(УникальныйИдентификаторФЗ);
		
		КонецЦикла;
		
	КонецЦикла;
	
	ВыйтиИзОбластиДанных(Область);
	
	Возврат "";
		
КонецФункции

#КонецОбласти

Процедура ПроверитьБлокировкуИнформационнойБазыДляОбновления()
	
	Если ЗначениеЗаполнено(ОбновлениеИнформационнойБазыСлужебный.ИнформационнаяБазаЗаблокированаДляОбновления()) Тогда
		
		ВызватьИсключение НСтр("ru = 'Синхронизация данных временно недоступна в связи с обновлением приложения в Интернете.';
								|en = 'Data synchronization is temporarily unavailable due to online application update.'");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьВыгрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена,
														КодУзлаИнформационнойБазы,
														ИдентификаторФайла,
														ДлительнаяОперация,
														ИдентификаторОперации,
														ДлительнаяОперацияРазрешена)
	
	КлючФоновогоЗадания = КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ИмяПланаОбмена,
		КодУзлаИнформационнойБазы,
		НСтр("ru = 'Выгрузка';
			|en = 'Export'"));
	
	Если ОбменДаннымиСервер.ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗадания) Тогда
		ВызватьИсключение НСтр("ru = 'Синхронизация данных уже выполняется.';
								|en = 'Data synchronization is already running.'");
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
	ПараметрыПроцедуры.Вставить("КодУзлаИнформационнойБазы", КодУзлаИнформационнойБазы);
	ПараметрыПроцедуры.Вставить("ИдентификаторФайла", ИдентификаторФайла);
	ПараметрыПроцедуры.Вставить("ИспользоватьСжатие", Истина);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Выгрузка данных через веб-сервис.';
															|en = 'Export data via web service.'");
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	ПараметрыВыполнения.ЗапуститьНеВФоне = Не ДлительнаяОперацияРазрешена;
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
		"ОбменДаннымиВебСервис.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыВСервисПередачиФайлов",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
		
	Если ФоновоеЗадание.Статус = "Выполняется" Тогда
		ИдентификаторОперации = Строка(ФоновоеЗадание.ИдентификаторЗадания);
		ДлительнаяОперация = Истина;
		Возврат;
	ИначеЕсли ФоновоеЗадание.Статус = "Выполнено" Тогда
		ДлительнаяОперация = Ложь;
		Возврат;
	Иначе
		Сообщение = НСтр("ru = 'Ошибка при выгрузке данных через веб-сервис.';
						|en = 'Error exporting data via web service.'");
		Если ЗначениеЗаполнено(ФоновоеЗадание.ПодробноеПредставлениеОшибки) Тогда
			Сообщение = ФоновоеЗадание.ПодробноеПредставлениеОшибки;
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииВыгрузкаДанныхВСервисПередачиФайлов(),
			УровеньЖурналаРегистрации.Ошибка, , , Сообщение);
		
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьВыгрузкуДанныхВКлиентСерверномРежимеВнутренняяПубликация(ИмяПланаОбмена,
		КодУзлаИнформационнойБазы, ИдентификаторЗадачи, ОбластьДанных)
			
	ПараметрыПроцедуры = Новый Массив;
	ПараметрыПроцедуры.Добавить(ИмяПланаОбмена);
	ПараметрыПроцедуры.Добавить(КодУзлаИнформационнойБазы);
	ПараметрыПроцедуры.Добавить(ИдентификаторЗадачи);
	
	Ключ = ИдентификаторЗадачи;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Ключ", Лев(Ключ, 120));
	ПараметрыЗадания.Вставить("ИмяМетода"    , "ОбменДаннымиВнутренняяПубликация.ВыполнитьВыгрузкуДляУзлаИнформационнойБазыВСервисПередачиФайлов");
	ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
	ПараметрыЗадания.Вставить("Использование", Истина);
	ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяДатаСеанса());
	ПараметрыЗадания.Вставить("Параметры", ПараметрыПроцедуры);
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
	ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 900);
	
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	
КонецПроцедуры

Процедура ВыполнитьЗагрузкуДанныхВКлиентСерверномРежиме(ИмяПланаОбмена,
													КодУзлаИнформационнойБазы,
													ИдентификаторФайла,
													ДлительнаяОперация,
													ИдентификаторОперации,
													ДлительнаяОперацияРазрешена)
	
													
	КлючФоновогоЗадания = КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ИмяПланаОбмена,
		КодУзлаИнформационнойБазы,
		НСтр("ru = 'Загрузка';
			|en = 'Import'"));
	
	Если ОбменДаннымиСервер.ЕстьАктивныеФоновыеЗадания(КлючФоновогоЗадания) Тогда
		ВызватьИсключение НСтр("ru = 'Синхронизация данных уже выполняется.';
								|en = 'Data synchronization is already running.'");
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
	ПараметрыПроцедуры.Вставить("КодУзлаИнформационнойБазы", КодУзлаИнформационнойБазы);
	ПараметрыПроцедуры.Вставить("ИдентификаторФайла", ИдентификаторФайла);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Загрузка данных через веб-сервис.';
															|en = 'Import data via web service.'");
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	ПараметрыВыполнения.ЗапуститьНеВФоне = Не ДлительнаяОперацияРазрешена;
	
	ФоновоеЗадание = ДлительныеОперации.ВыполнитьВФоне(
		"ОбменДаннымиВебСервис.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыИзСервисаПередачиФайлов",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
		
	Если ФоновоеЗадание.Статус = "Выполняется" Тогда
		ИдентификаторОперации = Строка(ФоновоеЗадание.ИдентификаторЗадания);
		ДлительнаяОперация = Истина;
		Возврат;
	ИначеЕсли ФоновоеЗадание.Статус = "Выполнено" Тогда
		ДлительнаяОперация = Ложь;
		Возврат;
	Иначе
		
		Сообщение = НСтр("ru = 'Ошибка при загрузке данных через веб-сервис.';
						|en = 'Error importing data via web service.'");
		Если ЗначениеЗаполнено(ФоновоеЗадание.ПодробноеПредставлениеОшибки) Тогда
			Сообщение = ФоновоеЗадание.ПодробноеПредставлениеОшибки;
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиСервер.СобытиеЖурналаРегистрацииЗагрузкаДанныхИзСервисаПередачиФайлов(),
			УровеньЖурналаРегистрации.Ошибка, , , Сообщение);
		
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьЗагрузкуДанныхВКлиентСерверномРежимеВнутренняяПубликация(ИмяПланаОбмена,
		КодУзлаИнформационнойБазы, ИдентификаторЗадачи, ИдентификаторФайла, ОбластьДанных)
		
	ПараметрыПроцедуры = Новый Массив;
	ПараметрыПроцедуры.Добавить(ИмяПланаОбмена);
	ПараметрыПроцедуры.Добавить(КодУзлаИнформационнойБазы);
	ПараметрыПроцедуры.Добавить(ИдентификаторЗадачи);
	ПараметрыПроцедуры.Добавить(ИдентификаторФайла);
	
	Ключ = ИдентификаторЗадачи;
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Ключ", Лев(Ключ, 120));
	ПараметрыЗадания.Вставить("ИмяМетода"    , "ОбменДаннымиВнутренняяПубликация.ВыполнитьЗагрузкуДляУзлаИнформационнойБазыИзСервисаПередачиФайлов");
	ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
	ПараметрыЗадания.Вставить("Использование", Истина);
	ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ТекущаяДатаСеанса());
	ПараметрыЗадания.Вставить("Параметры", ПараметрыПроцедуры);
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
	ПараметрыЗадания.Вставить("ИнтервалПовтораПриАварийномЗавершении", 900);
	
	МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
	МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	
КонецПроцедуры

Функция КлючФоновогоЗаданияВыгрузкиЗагрузкиДанных(ПланОбмена, КодУзла, Действие)
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'ПланОбмена:%1 КодУзла:%2 Действие:%3';
			|en = 'ExchangePlan:%1 NodeCode:%2 Action:%3'"),
		ПланОбмена,
		КодУзла,
		Действие);
	
КонецФункции

Функция ВременныйКаталогВыгрузки(Знач ИдентификаторСессии)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВременныйКаталог = "{ИдентификаторСессии}";
	ВременныйКаталог = СтрЗаменить(ВременныйКаталог, "ИдентификаторСессии", Строка(ИдентификаторСессии));
	
	Результат = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ОбменДаннымиСервер.КаталогВременногоХранилищаФайлов(), ВременныйКаталог);
	
	Возврат Результат;
	
КонецФункции

Функция НайтиФайлЧасти(Знач Каталог, Знач НомерФайла)
	
	Для КоличествоРазрядов = КоличествоРазрядовЧисла(НомерФайла) По 5 Цикл
		
		ФорматнаяСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧЦ=%1; ЧВН=; ЧГ=0", Строка(КоличествоРазрядов));
		
		ИмяФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("data.zip.%1", Формат(НомерФайла, ФорматнаяСтрока));
		
		ИменаФайлов = НайтиФайлы(Каталог, ИмяФайла);
		
		Если ИменаФайлов.Количество() > 0 Тогда
			
			Возврат ИменаФайлов;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Массив;
	
КонецФункции

Функция ПолучитьИмяФайлаЧасти(PartNumber)
	
	Результат = "data.zip.[n]";
	
	Возврат СтрЗаменить(Результат, "[n]", Формат(PartNumber, "ЧГ=0"));
	
КонецФункции

Функция КоличествоРазрядовЧисла(Знач Число)
	
	Возврат СтрДлина(Формат(Число, "ЧДЦ=0; ЧГ=0"));
	
КонецФункции

Процедура ПереместитьФайлСообщенияДляФайловойИБ(ИдентификаторФайла)
	
	Если НЕ ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Возврат;
	КонецЕсли;
		
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	СообщенияОбменаДанными.ИмяФайлаСообщения КАК ИмяФайла
		|ИЗ
		|	РегистрСведений.СообщенияОбменаДанными КАК СообщенияОбменаДанными
		|ГДЕ
		|	СообщенияОбменаДанными.ИдентификаторСообщения = &ИдентификаторСообщения";

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторСообщения", Строка(ИдентификаторФайла));
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ИмяФайла = Выборка.ИмяФайла;
	ИмяФайлаСообщения = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ОбменДаннымиСервер.КаталогВременногоХранилищаФайлов(), ИмяФайла);
	
	ИмяКаталога = ОбменДаннымиСервер.ИмяКаталогаДляСопоставленияФайловаяИБ();
	
	Каталог = Новый Файл(ИмяКаталога);
	Если Не Каталог.Существует() Тогда
		СоздатьКаталог(ИмяКаталога);
	КонецЕсли;

	ИмяНовогоФайлаСообщения = ОбменДаннымиСервер.ПолноеИмяФайлаДляСопоставленияФайловаяИБ(ИмяФайла);
	
	ПереместитьФайл(ИмяФайлаСообщения, ИмяНовогоФайлаСообщения);
	
КонецПроцедуры

Процедура ВойтиВОбластьДанных(ОбластьДанных)
	
	Если ОбластьДанных = 0 
		Или Не ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");

	МодульТехнологияСервиса = ОбщегоНазначения.ОбщийМодуль("ТехнологияСервиса");
	ВерсияБТС = МодульТехнологияСервиса.ВерсияБиблиотеки();

	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБТС, "2.0.7.46") >= 0 Тогда
		МодульРаботаВМоделиСервиса.ВойтиВОбластьДанных(ОбластьДанных); //АПК: 287
	Иначе
		МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, ОбластьДанных); //АПК: 222
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыйтиИзОбластиДанных(ОбластьДанных)
	
	Если ОбластьДанных = 0 
		Или Не ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");

	МодульТехнологияСервиса = ОбщегоНазначения.ОбщийМодуль("ТехнологияСервиса");
	ВерсияБТС = МодульТехнологияСервиса.ВерсияБиблиотеки();

	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияБТС, "2.0.7.46") >= 0 Тогда
		МодульРаботаВМоделиСервиса.ВыйтиИзОбластиДанных(); //АПК: 287
	Иначе
		МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь); //АПК: 222
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

