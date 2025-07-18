#Область СлужебныйПрограммныйИнтерфейс

Процедура ДополнитьФормуОрганизации(Форма) Экспорт
	
	Если Не ПроверитьУсловияДоступности(Форма, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнитьФормуСтандартно(Форма);
	
КонецПроцедуры

Процедура ДополнитьФормуПодразделения(Форма) Экспорт
	
	Если Не ПроверитьУсловияДоступности(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьРегистрациюВОрганеСтатистики(Форма, Истина);
	ПрочитатьРегистрациюПодразделенияСУчетомИерархии(Форма, Ложь);
	
КонецПроцедуры

Процедура ДополнитьФормуТерритории(Форма) Экспорт
	
	Если Не ПроверитьУсловияДоступности(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнитьФормуСтандартно(Форма);
	
КонецПроцедуры

Процедура ПрочитатьРегистрациюПодразделенияСУчетомИерархии(Форма, ПроверитьДоступность = Истина) Экспорт
	
	Если ПроверитьДоступность И Не ПроверитьДополнитьФорму(Форма, Истина) Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(Форма, "ИспользованиеРегистрацийВОрганеСтатистики", Форма.Объект.Ссылка);
	Если Не ЗначениеЗаполнено(Форма.ИспользованиеРегистрацийВОрганеСтатистики.Регистрация) Тогда
		МенеджерЗаписи = ПрочитатьРегистрациюГоловногоПодразделения(Форма.Объект.Родитель);
		Форма.ЗначениеВРеквизитФормы(МенеджерЗаписи, "ИспользованиеРегистрацийВОрганеСтатистикиГоловного");
	КонецЕсли;
	
	РегистрацииВОрганеСтатистикиКлиентСервер.НастроитьОтображениеРегистрацииВОрганеСтатистикиСУчетомИерархии(Форма);
	
КонецПроцедуры

Процедура ПрочитатьРегистрацию(Форма, ПроверитьДоступность = Истина) Экспорт
	
	Если Не ПроверитьДополнитьФорму(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(Форма, "ИспользованиеРегистрацийВОрганеСтатистики", Форма.Объект.Ссылка);
	РегистрацииВОрганеСтатистикиКлиентСервер.НастроитьОтображениеРегистрацииВОрганеСтатистики(Форма);
	
КонецПроцедуры

Процедура ЗаписатьРегистрациюВОрганеСтатистики(Форма) Экспорт
	
	Если Не РегистрацииВОрганеСтатистикиКлиентСервер.ИспользуютсяРегистрацииВОрганеСтатистики()
		Или Форма.Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРеквизита = "ИспользованиеРегистрацийВОрганеСтатистики";
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, ИмяРеквизита) Тогда
		Если Форма[ИмяРеквизита + "Прежняя"] <> Неопределено Тогда
			РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(Форма, ИмяРеквизита, Форма.Объект.Ссылка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрочитатьРегистрациюГоловногоПодразделения(Знач Родитель) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.ИспользованиеРегистрацийВОрганеСтатистики.СоздатьМенеджерЗаписи();
	
	Если Не ЗначениеЗаполнено(Родитель) Тогда
		Возврат МенеджерЗаписи;
	КонецЕсли;
	
	Предки = Новый ТаблицаЗначений;
	Предки.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"));
	Предки.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	Порядок = 1;
	Пока ЗначениеЗаполнено(Родитель) Цикл
		НоваяСтрока = Предки.Добавить();
		НоваяСтрока.Ссылка = Родитель;
		НоваяСтрока.Порядок = Порядок;
		Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "Родитель");
		Порядок = Порядок + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Предки.Ссылка КАК Ссылка,
		|	Предки.Порядок КАК Порядок
		|ПОМЕСТИТЬ ВТПредки
		|ИЗ
		|	&Предки КАК Предки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИспользованиеРегистрацийВОрганеСтатистики.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	ИспользованиеРегистрацийВОрганеСтатистики.Период КАК Период
		|ИЗ
		|	РегистрСведений.ИспользованиеРегистрацийВОрганеСтатистики.СрезПоследних КАК ИспользованиеРегистрацийВОрганеСтатистики
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПредки КАК Предки
		|		ПО (Предки.Ссылка = ИспользованиеРегистрацийВОрганеСтатистики.СтруктурнаяЕдиница)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Предки.Порядок");
	Запрос.УстановитьПараметр("Предки", Предки);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		МенеджерЗаписи.СтруктурнаяЕдиница = Выборка.СтруктурнаяЕдиница;
		МенеджерЗаписи.Период = Выборка.Период;
		МенеджерЗаписи.Прочитать();
	КонецЕсли;
	
	Возврат МенеджерЗаписи;
	
КонецФункции

Функция ПроверитьДополнитьФорму(Форма, ЕстьИерархия = Ложь)
	
	Если Не ПроверитьУсловияДоступности(Форма) Тогда
		Если ФормаДополнена(Форма) Тогда
			Форма.Элементы.ПредставлениеРегистрацииВОрганеСтатистики.Видимость = Ложь;
			Форма.Элементы.ИсторияИспользованияРегистрацииВОрганеСтатистики.Видимость = Ложь;
			Если ЕстьИерархия Тогда
				Форма.Элементы.ИзменитьРегистрациюВОрганеСтатистики.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ФормаДополнена(Форма) Тогда
		ДобавитьРегистрациюВОрганеСтатистики(Форма, ЕстьИерархия);
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПроверитьУсловияДоступности(Форма, ТолькоБазовыеУсловия = Ложь)
	
	Доступность = РегистрацииВОрганеСтатистикиКлиентСервер.ИспользуютсяРегистрацииВОрганеСтатистики()
		И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ИспользованиеРегистрацийВОрганеСтатистики);
	
	Если Не ТолькоБазовыеУсловия Тогда
		Доступность = Доступность И Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленныеПодразделения");
		РегистрацииВОрганеСтатистикиПереопределяемый.ДополнитьУсловияДоступности(Форма, Доступность);
	КонецЕсли;
	
	Возврат Доступность;
	
КонецФункции

Процедура ДополнитьФормуСтандартно(Форма)
	
	ДобавитьРегистрациюВОрганеСтатистики(Форма);
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(Форма, "ИспользованиеРегистрацийВОрганеСтатистики", Форма.Объект.Ссылка);
	РегистрацииВОрганеСтатистикиКлиентСервер.НастроитьОтображениеРегистрацииВОрганеСтатистики(Форма);
	
КонецПроцедуры

Функция ФормаДополнена(Форма)
	
	ИмяКомандыИстория = "ИсторияИспользованияРегистрацииВОрганеСтатистики";
	Если Форма.Команды.Найти(ИмяКомандыИстория) <> Неопределено Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьРегистрациюВОрганеСтатистики(Форма, ЕстьИерархия = Ложь)
	
	Если ФормаДополнена(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКомандыИстория = "ИсторияИспользованияРегистрацииВОрганеСтатистики";
	КомандаФормы = Форма.Команды.Добавить(ИмяКомандыИстория);
	КомандаФормы.Заголовок = НСтр("ru = 'История использования';
									|en = 'Usage history'");
	КомандаФормы.Действие = "Подключаемый_" + ИмяКомандыИстория;
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ПредставлениеРегистрацииВОрганеСтатистики",
		Новый ОписаниеТипов("ФорматированнаяСтрока"),, НСтр("ru = 'Регистрация отчитывающегося респондента Росстата';
															|en = 'Register a reporting respondent of the Russian Federal State Statistics Service'")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИспользованиеРегистрацийВОрганеСтатистики",
		Новый ОписаниеТипов("РегистрСведенийМенеджерЗаписи.ИспользованиеРегистрацийВОрганеСтатистики")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИспользованиеРегистрацийВОрганеСтатистикиНаборЗаписей",
		Новый ОписаниеТипов("РегистрСведенийНаборЗаписей.ИспользованиеРегистрацийВОрганеСтатистики")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИспользованиеРегистрацийВОрганеСтатистикиНаборЗаписейПрочитан",
		Новый ОписаниеТипов("Булево")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИспользованиеРегистрацийВОрганеСтатистикиНоваяЗапись",
		Новый ОписаниеТипов("Булево")));
	ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИспользованиеРегистрацийВОрганеСтатистикиПрежняя",
		Новый ОписаниеТипов(Неопределено)));
		
	Если ЕстьИерархия Тогда
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("ИспользованиеРегистрацийВОрганеСтатистикиГоловного",
			Новый ОписаниеТипов("РегистрСведенийМенеджерЗаписи.ИспользованиеРегистрацийВОрганеСтатистики")));
			
		ИмяКомандыИзменить = "ИзменитьРегистрациюВОрганеСтатистики";
		Если Форма.Команды.Найти(ИмяКомандыИзменить) <> Неопределено Тогда
			Возврат;
		КонецЕсли;
		КомандаФормы = Форма.Команды.Добавить(ИмяКомандыИзменить);
		КомандаФормы.Заголовок = НСтр("ru = 'Изменить';
										|en = 'Change'");
		КомандаФормы.Действие = "Подключаемый_" + ИмяКомандыИзменить;
			
	КонецЕсли;
		
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	ГруппаФормы = Форма.Элементы.Найти("ГруппаРегистрацияВОрганеСтатистики");
	Если Форма.Элементы.Найти("ПредставлениеРегистрацииВОрганеСтатистики") = Неопределено Тогда
		
		ГруппаФормы.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
		
		Элемент = Форма.Элементы.Добавить("ПредставлениеРегистрацииВОрганеСтатистики", Тип("ПолеФормы"), ГруппаФормы);
		Элемент.Вид = ВидПоляФормы.ПолеНадписи;
		Элемент.ПутьКДанным = "ПредставлениеРегистрацииВОрганеСтатистики";
		Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
		Элемент.ТолькоПросмотр = Истина;
		Элемент.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
		Элемент.РастягиватьПоВертикали = Ложь;
		Элемент.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ОткрытьРегистрациюВОрганеСтатистики");
		
		Элемент = Форма.Элементы.Добавить(ИмяКомандыИстория, Тип("КнопкаФормы"), ГруппаФормы);
		Элемент.Вид = ВидКнопкиФормы.Гиперссылка;
		Элемент.ИмяКоманды = ИмяКомандыИстория;
		
		Если ЕстьИерархия Тогда
			Элемент = Форма.Элементы.Добавить(ИмяКомандыИзменить, Тип("КнопкаФормы"), ГруппаФормы);
			Элемент.Вид = ВидКнопкиФормы.Гиперссылка;
			Элемент.ИмяКоманды = ИмяКомандыИзменить;
			Элемент.Доступность = Не Форма.ТолькоПросмотр;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти