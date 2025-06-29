#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// см. РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры, ФайлыКлассификатора) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИдентификаторыКлассификаторов = ОбщегоНазначенияЕГАИС.ИдентификаторыКлассификаторов();
	ОписаниеКлассификатора        = ИдентификаторыКлассификаторов[Идентификатор];
	
	НачатьТранзакцию();
	
	ДанныеУспешноЗагружены = Ложь;
	Блокировка             = Новый БлокировкаДанных();
	Блокировка.Добавить(Метаданные.РегистрыСведений.ВидыАлкогольнойПродукцииЕГАИС.ПолноеИмя());
	
	Попытка
		
		Блокировка.Заблокировать();
		
		Для Каждого ИмяФайла Из ФайлыКлассификатора Цикл
			
			Чтение = Новый ЧтениеJSON;
			Чтение.ОткрытьФайл(ИмяФайла);
			
			Попытка
				ДанныеКлассификатора = ПрочитатьJSON(Чтение);
			Исключение
				ДанныеКлассификатора = Неопределено;
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'Внутренняя ошибка. Не удалось прочитать исходные данные классификатора %1
					           |%2';
					           |en = 'Внутренняя ошибка. Не удалось прочитать исходные данные классификатора %1
					           |%2'"),
					ОписаниеКлассификатора.ВидКлассификатора,
					ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
			Чтение.Закрыть();
			
			Если ДанныеКлассификатора = Неопределено Тогда
				ВызватьИсключение ТекстОшибки
			КонецЕсли;
			
			ЗаполнитьДанныеПоВидамАлкогольнойПродукции(ДанныеКлассификатора);
			
		КонецЦикла;
		
		ДанныеУспешноЗагружены = Истина;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстОшибкиПодробно = СтрШаблон(
			НСтр("ru = 'Ошибка при обновлении классификатора %1:
			           |%2';
			           |en = 'Ошибка при обновлении классификатора %1:
			           |%2'"),
			ОписаниеКлассификатора.ВидКлассификатора,
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			ТекстОшибкиПодробно,
			НСтр("ru = 'Работа с классификаторами';
				|en = 'Работа с классификаторами'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
		ВызватьИсключение ТекстОшибкиПодробно;
		
	КонецПопытки;
	
	Если ДанныеУспешноЗагружены Тогда
		Обработан = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДанныеПоВидамАлкогольнойПродукции(ОбновленныеДанные)

	КлассификаторВидовАП = ОбновленныеДанные.КлассификаторВидовАП;
	ВидыТоваров       = ВидыПодакцизныхТоваров();
	
	Если КлассификаторВидовАП.Количество() Тогда
		НаборЗаписей = СоздатьНаборЗаписей();

		Для Каждого Строка Из КлассификаторВидовАП Цикл
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Строка);

            Запись.Наименование = Строка.ВидПродукции;
            
			Если ЗначениеЗаполнено(Строка.ВидПодакцизногоТовара) Тогда
				ВидТовара = ВидыТоваров.Получить(Строка.ВидПодакцизногоТовара);
				Если ВидТовара <> Неопределено Тогда
					Запись.ВидПодакцизногоТовара = ВидТовара;
				Иначе
					ВызватьИсключение НСтр("ru = 'Внутренняя ошибка поиска вида подакцизного товаров';
											|en = 'Внутренняя ошибка поиска вида подакцизного товаров'");
				КонецЕсли;
			КонецЕсли;

            ГруппаПродукции = Строка.ГруппаПродукции;
			Если ГруппаПродукции = "АП" Тогда
				Если Строка.Маркируемый Тогда
					Запись.ВидЛицензии = Перечисления.ВидыЛицензийАлкогольнойПродукции.АлкогольнаяПродукция;
				Иначе
					Запись.ВидЛицензии = Перечисления.ВидыЛицензийАлкогольнойПродукции.Пиво;
				КонецЕсли;
			ИначеЕсли ГруппаПродукции = "ССНП" Тогда
				Запись.ВидЛицензии = Перечисления.ВидыЛицензийАлкогольнойПродукции.СпиртосодержащаяНеПищеваяПродукция;
			ИначеЕсли ГруппаПродукции = "ССПП" Тогда
				Запись.ВидЛицензии = Перечисления.ВидыЛицензийАлкогольнойПродукции.СпиртосодержащаяПищеваяПродукция;
			ИначеЕсли ГруппаПродукции = "ЭС" Тогда
				Запись.ВидЛицензии = Перечисления.ВидыЛицензийАлкогольнойПродукции.Спирт;
			КонецЕсли;

		КонецЦикла;

		НаборЗаписей.Записать();
		
		ОбновитьУжеСуществующиеВидыАлкогольнойПродукции();
		
	КонецЕсли;
			
КонецПроцедуры

Функция ВидыПодакцизныхТоваров()
	
	ВидыТоваров = Новый Соответствие;
	
	Для каждого ПеречислениеСсылка Из Перечисления.ВидыПодакцизныхТоваровИС Цикл
		ВидыТоваров.Вставить(Строка(ПеречислениеСсылка), ПеречислениеСсылка);
		
	КонецЦикла;
	
	Возврат ВидыТоваров;
	
КонецФункции

Функция ВидыАлкогольнойПродукции() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыАлкогольнойПродукцииЕГАИС.Код,
		|	ВидыАлкогольнойПродукцииЕГАИС.Наименование,
		|	ВидыАлкогольнойПродукцииЕГАИС.ОКПД2,
		|	ВидыАлкогольнойПродукцииЕГАИС.ГруппаПродукции,
		|	ВидыАлкогольнойПродукцииЕГАИС.Маркируемый,
		|	ВидыАлкогольнойПродукцииЕГАИС.КодТНВЭД,
		|	ВидыАлкогольнойПродукцииЕГАИС.ВидПодакцизногоТовара,
		|	ВидыАлкогольнойПродукцииЕГАИС.ВидЛицензии
		|ИЗ
		|	РегистрСведений.ВидыАлкогольнойПродукцииЕГАИС КАК ВидыАлкогольнойПродукцииЕГАИС";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Возврат РезультатЗапроса; 
	
КонецФункции

Процедура ОбновитьУжеСуществующиеВидыАлкогольнойПродукции()
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыАлкогольнойПродукции.Ссылка КАК Ссылка,
		|	ВидыАлкогольнойПродукцииЕГАИС.ВидПодакцизногоТовара КАК ВидПодакцизногоТовара,
		|	ВидыАлкогольнойПродукцииЕГАИС.Маркируемый КАК Маркируемый
		|ИЗ
		|	Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВидыАлкогольнойПродукцииЕГАИС КАК ВидыАлкогольнойПродукцииЕГАИС
		|		ПО ВидыАлкогольнойПродукции.Код = ВидыАлкогольнойПродукцииЕГАИС.Код
		|ГДЕ
		|	ВидыАлкогольнойПродукции.ПометкаУдаления = ЛОЖЬ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ВидАлкогольнойПродукцииОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		
		ВидАлкогольнойПродукцииОбъект.ВидПодакцизногоТовара = ВыборкаДетальныеЗаписи.ВидПодакцизногоТовара;
		
		ВидАлкогольнойПродукцииОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли