////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры и функции общего назначения:
// - <<вставить предназначение модуля>>;
//  
////////////////////////////////////////////////////////////////////////////////


#Область ПрограммныйИнтерфейс

// Предназначен для запуска фонового задания для организации асинхронной обработки операций
//
// Параметры:
//	ИмяПроцедуры 		- Строка - полный путь запускаемой процедуры в общем модуле
//	ПараметрыПроцедуры 	- Структура - содержит именованные параметры для запуска процедур и функций
//
// Возвращаемое значение:
//	Структура - содержит описание созданного фононовое задание см. ДлительныеОперации.ВыполнитьВФоне()
//
Функция ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры) Экспорт
	
	ИдентификаторОперации = ПолучитьПолеСтруктуры(ПараметрыПроцедуры, "ИдентификаторОперации");
	ИдентификаторФормы = ПолучитьПолеСтруктуры(ПараметрыПроцедуры, "ИдентификаторФормы");
	СинхронныйРежим = ПолучитьПолеСтруктуры(ПараметрыПроцедуры, "СинхронныйРежим");
	
	Если ИдентификаторФормы = Неопределено Тогда
		ИдентификаторФормы = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	Если СинхронныйРежим = Неопределено Тогда
		СинхронныйРежим = Ложь;
	КонецЕсли;	
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	Если ИдентификаторОперации <> Неопределено Тогда
		ПараметрыВыполнения.Вставить("КлючФоновогоЗадания", Строка(ИдентификаторОперации));
	КонецЕсли;
	
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Вызов API сервиса регистрации ЮЛ/ИП';
															|en = 'Вызов API сервиса регистрации ЮЛ/ИП'") 
														+ ": " + ИмяПроцедуры;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ДополнительныйРезультат = Ложь;
	ПараметрыВыполнения.ЗапуститьНеВФоне = СинхронныйРежим;
	
	Если СтрНайти(ИмяПроцедуры, ".") = 0 Тогда
		Результат = ДлительныеОперации.ВыполнитьВФоне("ДокументооборотРегистрацияВФНСВызовСервера." + ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	Иначе
		Результат = ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Получение и подготовка результатов выполнения функции в фоне.
//
// Параметры:
//	ДлительнаяОперация - Структура
//	РеквизитыВХранилище - Строка
//
// Возвращаемое значение:
//	Структура
//
Функция ПолучитьРезультатВыполненияВФоне(ДлительнаяОперация, РеквизитыВХранилище = "") Экспорт
	
	ВсеПоля = Новый Структура();
	Если ЗначениеЗаполнено(РеквизитыВХранилище) Тогда
		ВсеПоля = Новый Структура(РеквизитыВХранилище);
	КонецЕсли;
	
	Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);	
	
	Для Каждого СтрокаКлюча Из ВсеПоля Цикл
		Результат[СтрокаКлюча.Ключ] = ПоместитьВоВременноеХранилище(Результат[СтрокаКлюча.Ключ]);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Обертка для получения данных о свойствах отправки
//
// Параметры:
//	ПредметОтправки - СправочникСсылка.ОтправкиРегистрацияЮЛ
//
// Возвращаемое значение:
//	см. ДокументооборотРегистрацияВФНС.СвойстваОтправкиРегистрацииЮЛ
//
Функция СвойстваОтправкиРегистрацииЮЛ(ПредметОтправки) Экспорт
	
	Возврат ДокументооборотРегистрацияВФНС.СвойстваОтправкиРегистрацииЮЛ(ПредметОтправки);
	
КонецФункции

// Обертка для получения данных о свойствах отправки.
//
// Параметры:
//	ПредметОтправки - ДокументСсылка.УведомлениеОСпецрежимахНалогообложения
//
// Возвращаемое значение:
//	см. ДокументооборотРегистрацияВФНС.СвойстваЗаявленияРегистрацииЮЛ
//
Функция СвойстваЗаявленияРегистрацииЮЛ(ПредметОтправки) Экспорт
	
	Возврат ДокументооборотРегистрацияВФНС.СвойстваЗаявленияРегистрацииЮЛ(ПредметОтправки);
	
КонецФункции

// Получает реальную ссылку на объект базы по ее навигационной ссылке
//
// Параметры:
//	НавигационнаяСсылка - Строка
//
// Возвращаемое значение:
//	СправочникСсылка.ОтправкиРегистрацияЮЛПрисоединенныеФайлы
//
Функция ПолучитьДанныеПоНавигационнойСсылке(НавигационнаяСсылка) Экспорт
	
	ПерваяТочка = Найти(НавигационнаяСсылка, "e1cib/data/");
    ВтораяТочка = Найти(НавигационнаяСсылка, "?ref=");
    
    ПредставлениеТипа = Сред(НавигационнаяСсылка, ПерваяТочка + 11, ВтораяТочка - ПерваяТочка - 11);
	ПредставлениеИдентификатора = Сред(НавигационнаяСсылка, ВтораяТочка + 5);
	ПредставлениеИдентификатора = Прав(ПредставлениеИдентификатора, 8) + "-"
								+ Сред(ПредставлениеИдентификатора, 21, 4) + "-"
								+ Сред(ПредставлениеИдентификатора, 17, 4) + "-"
								+ Лев(ПредставлениеИдентификатора, 4) + "-"
								+ Сред(ПредставлениеИдентификатора, 5, 12);
	
	Попытка
	    ТипСсылки = ПредопределенноеЗначение(ПредставлениеТипа + ".ПустаяСсылка");
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ТипСсылки);
		Результат = МенеджерОбъекта.ПолучитьСсылку(Новый УникальныйИдентификатор(ПредставлениеИдентификатора));
	Исключение
		Результат = Неопределено; 
	КонецПопытки;

	Возврат Результат;
	
КонецФункции

// Обертка для получения состояния этапов отправки.
//
// Параметры:
//	ОтправкаСсылка - СправочникСсылка.ОтправкиРегистрацияЮЛ
//
// Возвращаемое значение:
//	см. ДокументооборотРегистрацияВФНС.СформироватьЭтапыОтправки
//	
Функция СформироватьЭтапыОтправки(ОтправкаСсылка) Экспорт
	
	ВсеЭтапы = ДокументооборотРегистрацияВФНС.СформироватьЭтапыОтправки(ОтправкаСсылка);
	
	Возврат ВсеЭтапы;
	
КонецФункции

// Возвращает реестр не завершенных отправок заявления в сервис регистрации ЮЛ ФНС.
// В формируемый список добавляются только элементы, которые не требуют авторизации
// и отправленные в течении 2 месяцев
//
// Параметры:
//	Организация - СправочникСсылка.Организация
//
// Возвращаемое значение:
//	Массив из СправочникСсылка.ОтправкиРегистрацияЮЛ
//
Функция ПолучитьОтправкиПоОрганизации(Организация) Экспорт
	
	Результат = ДокументооборотРегистрацияВФНС.ПолучитьОтправкиПоОрганизации(Организация);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСАвторизация
//
Функция СервисРегистрацииФНСАвторизация(ПараметрыФункции, АдресРезультата = Неопределено) Экспорт
	
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	Подпись = ПолучитьПолеСтруктуры(ПараметрыФункции, "Подпись", "");
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСАвторизация(Токен, Подпись);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.ВыполнитьОперациюСервераРегистрацииЮЛ
//
Функция ВыполнитьОперациюСервераРегистрацииЮЛ(ПараметрыФункции, АдресРезультата = Неопределено) Экспорт
	
	ИмяМетода = ПараметрыФункции.ИмяМетода;
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	ОписаниеМетода = ОбщегоНазначения.СкопироватьРекурсивно(ПараметрыФункции.ОписаниеМетода);
	ОписаниеМетода.Вставить("Токен", Токен);
	
	Если ИмяМетода = "СервисРегистрацииФНССписокЗаявок" Тогда
		Результат = СервисРегистрацииФНССписокЗаявок(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСОтправитьЗаявку" Тогда
		Результат = СервисРегистрацииФНСОтправитьЗаявку(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСПолучитьЗаявку" Тогда
		Результат = СервисРегистрацииФНСПолучитьЗаявку(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСИнформацияОЗаявке" Тогда
		Результат = СервисРегистрацииФНСИнформацияОЗаявке(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНССписокОтветов" Тогда
		Результат = СервисРегистрацииФНССписокОтветов(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСФайлОтвета" Тогда
		Результат = СервисРегистрацииФНСФайлОтвета(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСПлатежныйДокумент" Тогда
		Результат = СервисРегистрацииФНСПлатежныйДокумент(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСПодключение" Тогда
		Результат = СервисРегистрацииФНСПодключение(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСАвторизация" Тогда
		Результат = СервисРегистрацииФНСАвторизация(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСФормаЗаявления" Тогда
		Результат = СервисРегистрацииФНСФормаЗявления(ОписаниеМетода, АдресРезультата);
	ИначеЕсли ИмяМетода = "СервисРегистрацииФНСНайтиЗаявку" Тогда
		Результат = СервисРегистрацииФНСНайтиЗаявку(ОписаниеМетода, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СоздатьОтправкуРегистрацииЮЛ
//
Функция СоздатьОтправкуРегистрацииЮЛ(ПараметрыОтправки, АдресРезультата = Неопределено) Экспорт
	
	Результат = ДокументооборотРегистрацияВФНС.СоздатьОтправкуРегистрацииЮЛ(ПараметрыОтправки);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СоздатьОтправкуРегистрацииЮЛ
//
Функция НайтиОтправкуРегистрацииЮЛ(ПараметрыОтправки, АдресРезультата = Неопределено) Экспорт
	
	ИдентификаторПредмета = СокрЛП(ПараметрыОтправки.ПредметОтправки.УникальныйИдентификатор());
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСНайтиЗаявку_20(
		ИдентификаторПредмета, ПараметрыОтправки.ИдентификаторОтправки, ПараметрыОтправки.ДатаОтправки);
		
	Если Результат.Выполнено Тогда
		РезультатЗаписи = ДокументооборотРегистрацияВФНС.ЗаписатьУдачнуюОтправку(ПараметрыОтправки, Результат.ИдентификаторЗаявления, Результат.ДатаОтправки, ПараметрыОтправки.ВерсияОбмена);
		Результат.Выполнено = РезультатЗаписи.Выполнено;
		Результат.Ошибка = РезультатЗаписи.Ошибка;
		
		Если РезультатЗаписи.Выполнено Тогда
			Результат.Вставить("Отправка", РезультатЗаписи.Отправка);
		КонецЕсли;
	КонецЕсли;
		
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.ОбновитьСтатусОтправкиРегистрацииЮЛ
//
Функция ОбновитьСтатусОтправкиРегистрацииЮЛ(ПараметрыВызова, АдресРезультата = Неопределено) Экспорт
	
	Результат = ДокументооборотРегистрацияВФНС.ОбновитьСтатусОтправкиРегистрацииЮЛ(ПараметрыВызова);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.ПодготовитьВыгрузкуФайлов
//
Функция ПодготовитьВыгрузкуФайлов(ПараметрыВызова, АдресРезультата = Неопределено) Экспорт
	
	Результат = ДокументооборотРегистрацияВФНС.ПодготовитьВыгрузкуФайлов(ПараметрыВызова.ОписаниеПакета);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для регистрации ошибок в журнале регистрации.
//
Процедура ЗаписьЖурналаРегистрацииДляОшибки(ПодробныйТекстОшибки, ДанныеБазы = Неопределено) Экспорт
	
	ДокументооборотРегистрацияВФНС.ЗаписьЖурналаРегистрацииДляОшибки(ПодробныйТекстОшибки, ДанныеБазы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСПодключение
//
Функция СервисРегистрацииФНСПодключение(ПараметрыФункции, АдресРезультата = Неопределено)
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСПодключение();
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНССписокЗаявок
//
Функция СервисРегистрацииФНССписокЗаявок(ПараметрыФункции, АдресРезультата = Неопределено)
	
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	ИмяФайла = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИмяФайла", "");
	Период = ПолучитьПолеСтруктуры(ПараметрыФункции, "Период", "");
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНССписокЗаявок(Токен, ИмяФайла, Период);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСОтправитьЗаявку
//
Функция СервисРегистрацииФНСОтправитьЗаявку(ПараметрыФункции, АдресРезультата = Неопределено)
	
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	ИмяФайла = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИмяФайла", "");
	ДанныеФайла = ПолучитьПолеСтруктуры(ПараметрыФункции, "ДанныеФайла", "");
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСОтправитьЗаявку(Токен, ИмяФайла, ДанныеФайла);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСПолучитьЗаявку
//
Функция СервисРегистрацииФНСПолучитьЗаявку(ПараметрыФункции, АдресРезультата = Неопределено)
	
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	ИдентификаторЗаявления = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИдентификаторЗаявления", "");
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСПолучитьЗаявку(Токен, ИдентификаторЗаявления);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСИнформацияОЗаявке
//
Функция СервисРегистрацииФНСИнформацияОЗаявке(ПараметрыФункции, АдресРезультата = Неопределено)
	
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	ИдентификаторЗаявления = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИдентификаторЗаявления", "");
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСИнформацияОЗаявке(Токен, ИдентификаторЗаявления);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНССписокОтветов
//
Функция СервисРегистрацииФНССписокОтветов(ПараметрыФункции, АдресРезультата = Неопределено)
	
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	ИдентификаторЗаявления = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИдентификаторЗаявления", "");
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНССписокОтветов(Токен, ИдентификаторЗаявления);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСФайлОтвета
//
Функция СервисРегистрацииФНСФайлОтвета(ПараметрыФункции, АдресРезультата = Неопределено)
	
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	ИдентификаторЗаявления = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИдентификаторЗаявления", "");
	ИдентификаторОтвета = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИдентификаторОтвета", "");
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСФайлОтвета(Токен, ИдентификаторЗаявления, ИдентификаторОтвета);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСПлатежныйДокумент
//
Функция СервисРегистрацииФНСПлатежныйДокумент(ПараметрыФункции, АдресРезультата = Неопределено)
	
	Токен = ПолучитьПолеСтруктуры(ПараметрыФункции, "Токен", "");
	ПлатежныйДокумент = ПолучитьПолеСтруктуры(ПараметрыФункции, "ПлатежныйДокумент", Новый Структура);
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСПлатежныйДокумент(Токен, ПлатежныйДокумент);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСФормаЗявления
//
Функция СервисРегистрацииФНСФормаЗявления(ПараметрыФункции, АдресРезультата = Неопределено)
	
	ВыгрузкаЗаявления = ПолучитьПолеСтруктуры(ПараметрыФункции, "ВыгрузкаЗаявления", "");
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСФормаЗявления(ВыгрузкаЗаявления);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Обертка для организации фонового задания и серверного вызова см. ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСНайтиЗаявку
//
Функция СервисРегистрацииФНСНайтиЗаявку(ПараметрыФункции, АдресРезультата = Неопределено)
	
	ИдентификаторОтправки = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИдентификаторОтправки", "");
	ИдентификаторПредмета = ПолучитьПолеСтруктуры(ПараметрыФункции, "ИдентификаторПредмета", "");
	ДатаОтправки = ПолучитьПолеСтруктуры(ПараметрыФункции, "ДатаОтправки", '00010101');
	
	Результат = ДокументооборотРегистрацияВФНС.СервисРегистрацииФНСНайтиЗаявку_20(ИдентификаторПредмета, ИдентификаторОтправки, ДатаОтправки);
	
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПолеСтруктуры(ТекущиеДанные, ИмяКлюча, ЗначениеПоУмолчанию = Неопределено)
	
	Возврат ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ТекущиеДанные, ИмяКлюча, ЗначениеПоУмолчанию);
	
КонецФункции

#КонецОбласти
