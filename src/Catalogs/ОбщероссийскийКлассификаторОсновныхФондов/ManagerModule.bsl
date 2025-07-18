#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает реквизиты справочника, которые образуют естественный ключ
//  для элементов справочника.
//
// Возвращаемое значение:
//  Массив(Строка) - массив имен реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриДобавленииКлассификаторов(Классификаторы) Экспорт
	
	Классификаторы.Добавить(КлассификаторыУчреждений.ОписаниеОКОФ());
	
КонецПроцедуры

Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан) Экспорт
	
	Содержимое = КлассификаторыУчреждений.СодержимоеОКОФ(Идентификатор, Адрес);
	
	Если Содержимое = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоЭлементов = Содержимое.Количество;
	Содержание          = Содержимое.Данные;
	
	Обработано = 0;
	Родитель = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка();
	
	НачатьТранзакцию();
	Попытка
		// Устанавливаем исключительную блокировку на справочник, чтобы предотвратить
		// параллельный запуск обновления классификатора из другого сеанса.
		БлокировкаДанных = Новый БлокировкаДанных();
		ЭлементБлокировки = БлокировкаДанных.Добавить("Справочник.ОбщероссийскийКлассификаторОсновныхФондов");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		ЗаписатьКоллекциюВСправочник(Содержание.Строки, Родитель, Обработано, КоличествоЭлементов);
		Обработан = Истина;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление ОКОФ';
										|en = 'RNCFA update'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьКоллекциюВСправочник(Коллекция, Родитель, Обработано, КоличествоЭлементов)
	
	Пробелы = "                                                  "; // 50 пробелов (для «добивки» до длины кода)
	МетаданныеСправочника = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.ПустаяСсылка().Метаданные();
		
	Для Каждого Строка Из Коллекция Цикл
		
		Обработано = Обработано + 1;
		
		Если КоличествоЭлементов > 0 Тогда
			Процент = Окр(100 * Обработано / КоличествоЭлементов);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 из %2';
					|en = '%1 out of %2'"), Формат(Обработано, "ЧГ="), Формат(КоличествоЭлементов, "ЧГ="));
			ДлительныеОперации.СообщитьПрогресс(Процент, ТекстСообщения);
		КонецЕсли;
		
		ТекСсылка = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.НайтиПоКоду(Строка.Код);
		
		// Создание элемента
		Если ТекСсылка.Пустая() Тогда
			Объект = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.СоздатьЭлемент();
		Иначе
			Объект = ТекСсылка.ПолучитьОбъект();
			// Если элемент справочника удалили, пока ссылка на него хранилась в дереве.
			Если Объект = Неопределено Тогда
				Объект = Справочники.ОбщероссийскийКлассификаторОсновныхФондов.СоздатьЭлемент();
				Объект.УстановитьСсылкуНового(ТекСсылка);
			КонецЕсли;
		КонецЕсли;

		Попытка
			Объект.Заблокировать();
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление ОКОФ';
											|en = 'RNCFA update'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ВызватьИсключение;
		КонецПопытки;
		
		Если Объект.Заблокирован() Тогда
			
			// Заполнение элемента
			УстановитьНовоеЗначение(Объект.Родитель, Родитель);
			УстановитьНовоеЗначение(Объект.ПометкаУдаления, Ложь);
			УстановитьНовоеЗначение(Объект.НаименованиеГруппировки, Строка.Наименование);
			
			Если Объект.Модифицированность() Или Объект.ЭтоНовый() Тогда // уже бессмысленно проверять, изменились ли значения свойств
				
				ЗаполнитьЗначенияСвойств(Объект, Строка);
				
			Иначе
				
				Реквизиты = МетаданныеСправочника.Реквизиты;
				Для Каждого Свойство Из Строка.Свойства() Цикл
					
					Если ТипЗнч(Свойство.Тип) = Тип("ТипЗначенияXDTO") Тогда
						ИмяСвойства = Свойство.Имя;
						
						Если НРег(ИмяСвойства) = "код" Или НРег(ИмяСвойства) = "code" Тогда
							УстановитьНовоеЗначение(Объект.Код, Лев(Строка(Строка[ИмяСвойства]) + Пробелы, МетаданныеСправочника.ДлинаКода));
						ИначеЕсли НРег(ИмяСвойства) = "наименование" Или НРег(ИмяСвойства) = "description" Тогда
							УстановитьНовоеЗначение(Объект.Наименование, Строка[ИмяСвойства]);
						ИначеЕсли Реквизиты.Найти(ИмяСвойства) <> Неопределено Тогда
							УстановитьНовоеЗначение(Объект[ИмяСвойства], Строка[ИмяСвойства]);
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Объект.ОбменДанными.Загрузка = Истина;
			Объект.ДополнительныеСвойства.Вставить("ОбъектXDTO", Строка);
			Объект.ДополнительныеСвойства.Вставить("ЗагрузкаКлассификаторов", Истина);
			
			Если Объект.Модифицированность() Или Объект.ЭтоНовый() Тогда
				Объект.Записать();
			КонецЕсли;
			
		КонецЕсли;

		Если Строка.Свойства().Получить("amort_group") <> Неопределено Тогда
			
			xdtoАмортизационныеГруппы = Строка.amort_group;
			Если ТипЗнч(xdtoАмортизационныеГруппы) = Тип("ОбъектXDTO") Тогда // а не СписокXDTO
				
				ПодставнойМассив = Новый Массив;
				ПодставнойМассив.Добавить(xdtoАмортизационныеГруппы);
				xdtoАмортизационныеГруппы = ПодставнойМассив;
				
			КонецЕсли;
			
			Если xdtoАмортизационныеГруппы.Количество() > 0 Тогда
				
				НаборЗаписей = РегистрыСведений.АмортизационныеГруппыОКОФ.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ОКОФ.Установить(Объект.Ссылка);
				Для Каждого xdtoСсылкаНаАмортизационнуюГруппу Из xdtoАмортизационныеГруппы Цикл
					НомерГруппы = Число(xdtoСсылкаНаАмортизационнуюГруппу.АмортизационнаяГруппа);
					Если НомерГруппы = 0 Тогда //отдельная группа
						НомерГруппы = 11
					КонецЕсли;
					АмортизационнаяГруппа = Перечисления.АмортизационныеГруппы[НомерГруппы - 1];
					
					Запись = НаборЗаписей.Добавить();
					Запись.Активность            = Истина;
					Запись.ОКОФ                  = Объект.Ссылка;
					Запись.АмортизационнаяГруппа = АмортизационнаяГруппа;
					Запись.Примечание            = xdtoСсылкаНаАмортизационнуюГруппу.Примечание;
				КонецЦикла;
				НаборЗаписей.Записать(Истина);
				
			КонецЕсли;
			
		КонецЕсли;
	
		ЗаписатьКоллекциюВСправочник(Строка.Строки, Объект.Ссылка, Обработано, КоличествоЭлементов);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьНовоеЗначение(Параметр, Значение)
	
	Если Параметр <> Значение Тогда
		Параметр = Значение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли